class BostonEvents::Event
  attr_accessor :name, :dates, :sponsor, :venue, :deal_url, :website_url, :category
  @@all = []

  def self.all
    @@all
  end

  def save
    if !self.class.all.detect { | saved_event | saved_event.name == self.name }
      @@all << self
    end
  end

  def self.list_events(category) ##This needs to be refactored
    if category.events.length == 0
      if category.name == 'top-ten'
        doc = Nokogiri::HTML(open(SCRAPE_SELECTORS['top-ten'][:url]))
        item_list = doc.search(SCRAPE_SELECTORS['top-ten'][:iterate_over]).each_with_index do | this_event, index |
          scrape_events('top-ten',category,this_event)
        end
      else
        doc = Nokogiri::HTML(open(SCRAPE_SELECTORS['featured'][:url] + "#{category.name}/"))
        item_list = doc.search(SCRAPE_SELECTORS['featured'][:iterate_over]).each_with_index do | this_event, index |
          scrape_events('featured',category,this_event)
        end
        item_list = doc.search(SCRAPE_SELECTORS['listed'][:iterate_over]).each_with_index do | this_event, index |
          scrape_events('listed',category,this_event)
        end
      end
    end
  end

  SCRAPE_SELECTORS = {
    "top-ten" => {
      url: "http://calendar.artsboston.org/",
      iterate_over: "section.list-blog article.blog-itm",
      name: "h2.blog-ttl",
      dates: "div.left-event-time.evt-date-bubble",
      sponsor_and_venue_names: "p.meta",
      event_urls: "div.b-btn.__inline_block_fix_space a"
    },
    "featured" => {
      url: "http://calendar.artsboston.org/categories/",
      iterate_over: "article.category-detail",
      name: "h1.p-ttl",
      dates: "div.left-event-time.evt-date-bubble",
      sponsor_and_venue_names: "p.meta",
      event_urls: "div.b-btn.cat-detail.__inline_block_fix_space a"
    },
    "listed" => {
      url: "http://calendar.artsboston.org/categories/",
      iterate_over: "section.list-category article.category-itm",
      name: "h2.category-ttl",
      dates: "div.left-event-time.evt-date-bubble",
      sponsor_and_venue_names: "p.meta",
      event_urls: "div.b-btn.category a"
    }
  }

  def self.scrape_events(type, category, this_event)
    event = self.new
    event.name = this_event.search(SCRAPE_SELECTORS[type][:name]).text.strip
    dates = this_event.search(SCRAPE_SELECTORS[type][:dates])
    event.dates = get_event_dates(dates)
    sponsor_name = this_event.search(SCRAPE_SELECTORS[type][:sponsor_and_venue_names])[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
    event.add_sponsor(sponsor_name)
    venue_name = this_event.search(SCRAPE_SELECTORS[type][:sponsor_and_venue_names])[0].text.split(" at ")[1].strip
    event.add_venue(venue_name)
    if this_event.search(SCRAPE_SELECTORS[type][:event_urls])[1]
      event.deal_url = this_event.search(SCRAPE_SELECTORS[type][:event_urls])[1].attribute("href")
    end
    if this_event.search(SCRAPE_SELECTORS[type][:event_urls])[0]
      event.website_url = this_event.search(SCRAPE_SELECTORS[type][:event_urls])[0].attribute("href")
    end
    event.add_category(category)
    event.save
  end

  def self.get_event_dates(dates)
    if dates.search("div.date").length > 0
      dates.search("div.month").text.gsub(/\s+/," ").strip + " - " + dates.search("div.date").text.gsub(/\s+/," ").strip
    else
      dates.search("div.month").text.gsub(/\s+/," ").strip
    end
  end

  def add_category(category)
    self.category = category
    category.events << self
  end

  def add_venue(venue_name)
    venue = BostonEvents::Venue.find_or_create_by_name(venue_name)
    self.venue = venue
    venue.events << self
  end

  def add_sponsor(sponsor_name)
    sponsor = BostonEvents::Sponsor.find_or_create_by_name(sponsor_name)
    self.sponsor = sponsor
    sponsor.events << self
  end

end

class BostonEvents::Event
  attr_accessor :name, :dates, :sponsor, :venue, :deal_url, :website_url, :category
  @@all = []

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

  def self.all
    @@all
  end

  def save
    @@all << self if !self.class.all.detect { | saved_event | saved_event.name == self.name }
  end

  def self.list_events(category)
    if category.events.length == 0
      if category.name == 'top-ten'
        doc = Nokogiri::HTML(open(SCRAPE_SELECTORS[category.name][:url]))
        scrape_iterator(category, category.name, doc)
      else
        doc = Nokogiri::HTML(open(SCRAPE_SELECTORS['featured'][:url] + "#{category.name}/"))
        scrape_iterator(category, 'featured', doc)
        scrape_iterator(category, 'listed', doc)
      end # if/else
    end # if
  end

  def self.scrape_iterator(category, type, doc)
    item_list = doc.search(SCRAPE_SELECTORS[type][:iterate_over]).each_with_index do | this_event, index |
      scrape_events(type,category,this_event)
    end
  end

  def self.scrape_events(type, category, this_event)
    event = self.new
    event.name = this_event.search(SCRAPE_SELECTORS[type][:name]).text.strip

    dates = this_event.search(SCRAPE_SELECTORS[type][:dates])
    event.dates = get_event_dates(dates)

    sponsor_name = this_event.search(SCRAPE_SELECTORS[type][:sponsor_and_venue_names])[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
    event.add_sponsor(sponsor_name)

    venue_name = this_event.search(SCRAPE_SELECTORS[type][:sponsor_and_venue_names])[0].text.split(" at ")[1].strip
    event.add_venue(venue_name)

    event.deal_url = this_event.search(SCRAPE_SELECTORS[type][:event_urls])[1].attribute("href") if this_event.search(SCRAPE_SELECTORS[type][:event_urls])[1]
    event.website_url = this_event.search(SCRAPE_SELECTORS[type][:event_urls])[0].attribute("href") if this_event.search(SCRAPE_SELECTORS[type][:event_urls])[0]

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

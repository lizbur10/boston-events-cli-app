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

  def self.list_events(category)
    if category.events.length == 0
      # if category.name == 'top-ten'
      #   scrape_top_ten_events(category)
      # else
        scrape_events(category)
      # end
    end
  end

  # def self.scrape_events(category)
  #   # doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/#{category.name}/"))
  #   scrape_featured_event(doc, category)
  #   scrape_listed_events(doc, category)
  # end

  SCRAPE_SELECTORS = {
    "top-ten" => {
      url: "http://calendar.artsboston.org/",
      iterate_over: "section.list-blog article.blog-itm",
      name: "h2.blog-ttl",
      dates: "div.left-event-time.evt-date-bubble",
      sponsor_and_venue_names: "p.meta",
      event_urls: "div.b-btn.__inline_block_fix_space a"
    }
  }

  def self.scrape_events(category)
    doc = Nokogiri::HTML(open(SCRAPE_SELECTORS[category.name][:url]))
    item_list = doc.search(SCRAPE_SELECTORS[category.name][:iterate_over]).each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search(SCRAPE_SELECTORS[category.name][:name]).text.strip
      dates = this_event.search(SCRAPE_SELECTORS[category.name][:dates])
      event.dates = get_event_dates(dates)
      sponsor_name = this_event.search(SCRAPE_SELECTORS[category.name][:sponsor_and_venue_names])[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      event.add_sponsor(sponsor_name)
      venue_name = this_event.search(SCRAPE_SELECTORS[category.name][:sponsor_and_venue_names])[0].text.split(" at ")[1].strip
      event.add_venue(venue_name)
      if this_event.search(SCRAPE_SELECTORS[category.name][:event_urls])[1]
        event.deal_url = this_event.search(SCRAPE_SELECTORS[category.name][:event_urls])[1].attribute("href")
      end
      event.website_url = this_event.search(SCRAPE_SELECTORS[category.name][:event_urls])[0].attribute("href")
      event.add_category(category)
      event.save
    end
  end

  def self.scrape_top_ten_events(category)
    # doc = Nokogiri::HTML(open("http://calendar.artsboston.org/"))
    # item_list = doc.search("section.list-blog article.blog-itm").each_with_index do | this_event, index |
    #   event = self.new
      # event.name = this_event.search("h2.blog-ttl").text.strip
      # dates = this_event.search("div.left-event-time.evt-date-bubble")
      # event.dates = get_event_dates(dates)
      # sponsor_name = this_event.search("p.meta")[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      # event.add_sponsor(sponsor_name)
      # venue_name = this_event.search("p.meta")[0].text.split(" at ")[1].strip
      # event.add_venue(venue_name)
      # if this_event.search("div.b-btn.__inline_block_fix_space a")[1]
      #   event.deal_url = this_event.search("div.b-btn.__inline_block_fix_space a")[1].attribute("href")
      # end
      # event.website_url = this_event.search("div.b-btn.__inline_block_fix_space a")[0].attribute("href")
      # event.add_category(category)
      # event.save
    # end #each with index
  end

  def self.scrape_featured_event(doc, category)
    event = self.new
    event.name = doc.search("article.category-detail h1.p-ttl").text
    dates = doc.search("article.category-detail div.left-event-time.evt-date-bubble")
    event.dates = get_event_dates(dates)
    sponsor_name = doc.search("article.category-detail p.meta.auth a")[0].text
    event.add_sponsor(sponsor_name)
    venue_name = doc.search("p.meta")[0].text.split(" at ")[1].strip
    event.add_venue(venue_name)
    if doc.search("div.b-btn.cat-detail.__inline_block_fix_space a")[1]
      event.deal_url = doc.search("div.b-btn.cat-detail.__inline_block_fix_space a")[1].attribute("href")
    end
    event.website_url = doc.search("div.b-btn.cat-detail.__inline_block_fix_space a")[0].attribute("href")
    event.add_category(category)
    event.save
  end

  def self.scrape_listed_events(doc, category)
    item_list = doc.search("section.list-category article.category-itm").each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search("h2.category-ttl").text.strip
      dates = this_event.search("div.left-event-time.evt-date-bubble")
      event.dates = get_event_dates(dates)
      sponsor_name = this_event.search("p.meta")[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      event.add_sponsor(sponsor_name)
      venue_name = this_event.search("p.meta")[0].text.split(" at ")[1].strip
      event.add_venue(venue_name)
      if this_event.search("div.b-btn.category a")[1]
        event.deal_url = this_event.search("div.b-btn.category a")[1].attribute("href")
      end
      if this_event.search("div.b-btn.category a")[0]
        event.website_url = this_event.search("div.b-btn.category a")[0].attribute("href")
      end
      event.add_category(category)
      event.save
    end #each with index
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

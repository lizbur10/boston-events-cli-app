class BostonEvents::Event
  attr_accessor :name, :dates, :presented_by, :venue, :category
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
    if category.events.length == 0 #to keep events from being created twice if the same category is chosen more than once
      if category.name == 'top-ten'
        scrape_top_ten(category)
      else
        scrape_events(category)
      end
    end
  end

  def self.scrape_events(category)
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/#{category.name}/"))
    scrape_featured_item(doc, category)
    scrape_listed_items(doc, category)
  end

  def self.scrape_top_ten(category)
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/"))
    item_list = doc.search("section.list-blog article.blog-itm").each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search("h2.blog-ttl").text.strip
      dates = this_event.search("div.left-event-time.evt-date-bubble")
      event.dates = get_event_dates(dates)
      event.presented_by = this_event.search("p.meta")[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      event.add_category(category)
      event.save
    end #each with index
  end

  def self.scrape_featured_item(doc, category)
    event = self.new
    event.name = doc.search("article.category-detail h1.p-ttl").text
    dates = doc.search("article.category-detail div.month") ######## Does this work for all featured items????
    event.dates = get_event_dates(dates)
    event.presented_by = doc.search("article.category-detail p.meta.auth a")[0].text
    event.add_category(category)
    event.save
  end

  def self.scrape_listed_items(doc, category)
    item_list = doc.search("section.list-category article.category-itm").each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search("h2.category-ttl").text.strip
      dates = this_event.search("div.left-event-time.evt-date-bubble")
      event.dates = get_event_dates(dates)
      event.presented_by = this_event.search("p.meta").text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
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

end

class BostonEvents::Event
  attr_accessor :name, :dates, :presented_by, :venue
  @@all = []

  def all
    @@all
  end

  def self.list_events(category)
    if category == 'top-ten'
      scrape_home_page
    else
      scrape_events(category)
    end
    puts_events
  end

  def self.puts_events ## Need to switch this to do it by category instead of @@all
    @@all.each.with_index(1) { | event, index | puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.presented_by}" }
      puts "Type a number to see more info about that event or type list to see the list of categories again"
  end

  def self.scrape_events(category)
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/#{category}/"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  ## Top Ten
  def self.scrape_home_page
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/"))
    puts "coding in progress - pick another number"
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  def self.scrape_featured_item(doc)
    event = self.new
    event.name = doc.search("article.category-detail h1.p-ttl").text
    dates = doc.search("article.category-detail div.month") ## Does this work for all featured items????
    event.dates = get_event_dates(dates)
    event.presented_by = doc.search("article.category-detail p.meta.auth a")[0].text
    @@all << event
  end

  def self.scrape_listed_items(doc)
    item_list = doc.search("section.list-category article.category-itm").each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search("h2.category-ttl").text.strip
      dates = this_event.search("div.left-event-time.evt-date-bubble")
      event.dates = get_event_dates(dates)
      event.presented_by = this_event.search("p.meta").text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      @@all << event
    end #each with index
  end

  def self.get_event_dates(dates)
    if dates.search("div.date").length > 0
      dates.search("div.month").text.gsub(/\s+/," ").strip + " - " + dates.search("div.date").text.gsub(/\s+/," ").strip
    else
      dates.search("div.month").text.gsub(/\s+/," ").strip
    end
  end

end

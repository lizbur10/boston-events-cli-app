class BostonEvents::Event
  attr_accessor :name, :dates, :presented_by, :venue
  @@all = []

  def all
    @@all
  end

  def self.list_events(category)
    case category
    when "stage"
      scrape_stage_events
    when "music"
      scrape_music_events
    when "art"
      scrape_art_events
    when "kids"
      scrape_kids_events
    when "top-ten"
      scrape_top_ten
    end
    puts_events
  end

  def self.puts_events ## Need to switch this to do it by category instead of @@all
    @@all.each.with_index(1) { | event, index | puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.presented_by}" }
      puts "Type a number to see more info about that event or type list to see the list of categories again"
  end

  def self.scrape_stage_events
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/stage/"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  def self.scrape_music_events
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/music/"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
    end

  def self.scrape_art_events ## This one broke
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/art/"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  def self.scrape_kids_events
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/kids/"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  ## This one will be different...
  def self.scrape_top_ten
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories//"))
    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  ########Refactor featured item code to try to make consistent with listed item code and modularize
  def self.scrape_featured_item(doc)
    event = self.new
    event.name = doc.search("article.category-detail h1.p-ttl").text
    # event.dates = doc.search("article.category-detail div.month").text.split("\n")[1].strip + " " + doc.search("article.category-detail div.month").text.split("\n")[2].strip
    dates = doc.search("article.category-detail div.month")
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
  end #scrape_listed_items

  def self.get_event_dates(dates)
    if dates.search("div.date").length > 0
      dates.search("div.month").text.gsub(/\s+/," ").strip + " - " + dates.search("div.date").text.gsub(/\s+/," ").strip
    else
      dates.search("div.month").text.gsub(/\s+/," ").strip
    end
  end

end

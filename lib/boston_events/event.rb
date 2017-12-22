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

  def self.puts_events
    @@all.each { | event | puts "#{event.name} - #{event.dates} - #{event.presented_by}" }
  end

  def self.scrape_stage_events
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/stage/"))
    binding.pry

    scrape_featured_item(doc)
    scrape_listed_items(doc)
  end

  def self.scrape_featured_item(doc)
    event = self.new
    event.name = doc.search("article.category-detail h1.p-ttl").text
    ########Refactor DATES code using code for scrape_listed_events
    event.dates = doc.search("article.category-detail div.month").text.split("\n")[1].strip + " " + doc.search("article.category-detail div.month").text.split("\n")[2].strip
    event.presented_by = doc.search("article.category-detail p.meta.auth a")[0].text
    @@all << event
  end

  def self.scrape_listed_items(doc)
    item_list = doc.search("section.list-category article.category-itm").each_with_index do | this_event, index |
      event = self.new
      event.name = this_event.search("h2.category-ttl").text.strip
      dates = this_event.search("div.left-event-time.evt-date-bubble")
      if dates.search("div.date")
        begin_date = dates.search("div.month").text.gsub(/\s+/," ").strip
        end_date = dates.search("div.date").text.gsub(/\s+/," ").strip
        event.dates = "#{begin_date} - #{end_date}"
      else
        event.dates = dates.search("div.month").text.gsub(/\s+/," ").strip
      end #if/else
      event.presented_by = this_event.search("p.meta").text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
      @@all << event
    end #each with index
  end #scrape_listed_items

  # def self.scrape_music_events
  #
  # end
  #
  # def self.scrape_art_events
  #
  # end
  #
  # def self.scrape_kids_events
  #
  # end
  #
  # def self.scrape_top_ten
  #
  # end


end

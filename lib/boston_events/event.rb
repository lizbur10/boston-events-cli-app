class BostonEvents::Event
  attr_accessor :name, :dates, :presented_by, :venue

  # def self.list_events(category)
  def self.list_events #will add category in later

    event_1 = self.new
    event_1.name = "A Christmas Celtic Sojourn with Brian O'Donovan in Boston"
    event_1.dates = "Dec 14-22"
    event_1.presented_by = "WGBH"

    event_2 = self.new
    event_2.name = "A Christmas Carol"
    event_2.dates = "Dec 15-23"
    event_2.presented_by = "The Hanover Theatre for the Performing Arts"

    [event_1,event_2]
  end

  def self.scrape_stage_events
    stage_events = []
    doc = Nokogiri::HTML(open("http://calendar.artsboston.org/categories/stage/"))
    binding.pry
    name = doc.search("article.category-detail h1.p-ttl").text  ##Featured event wrapped in article.category-detail
    dates = doc.search("article.category-detail div.month").text.split("\n")[1].strip + " " + doc.search("article.category-detail div.month").text.split("\n")[2].strip
    presented_by = doc.search("article.category-detail p.meta.auth a")[0].text
  end

  def self.scrape_music_events

  end

  def self.scrape_art_events

  end

  def self.scrape_kids_events

  end

  def self.scrape_top_ten

  end
end

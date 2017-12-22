class BostonEvents::Event
  attr_accessor :name, :dates, :presented_by, :venue

  # def self.list_events(category)
  def self.list_events #(category)

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

    ## Featured Item - wrapped in article.category-detail
    # def scrape_featured_item
      name = doc.search("article.category-detail h1.p-ttl").text
      dates = doc.search("article.category-detail div.month").text.split("\n")[1].strip + " " + doc.search("article.category-detail div.month").text.split("\n")[2].strip
      presented_by = doc.search("article.category-detail p.meta.auth a")[0].text
    # end

    ## Listed items - list wrapped in section.list-category; individual events wrapped in article.category-item
    ## NAME
    name_list = doc.search("h2.category-ttl")
    index = 0
    event_name = []
    name_list.each do | name |
      event_name[index] = name.text.strip
      index += 1
    end
    binding.pry

    ## DATES
    dates_list = doc.search("article.category-itm div.left-event-time.evt-date-bubble")
    event_dates = []
    dates_list.each_with_index do | dates, index |
      # puts event_dates.search("div.month")[0].text
      if dates.search("div.date")[0]
        begin_date = dates.search("div.month")[0].text.gsub(/\s+/," ").strip
        end_date = dates.search("div.date")[0].text.gsub(/\s+/," ").strip
        event_dates[index] = "#{begin_date} - #{end_date}"
      else
        event_dates[index] = dates.search("div.month")[0].text.gsub(/\s+/," ").strip
      end
    end

    ## PRESENTED BY
    presented_by_list = doc.css("article.category-itm p.meta")
    event_presented_by = []
    presented_by_list.each_with_index do | presented_by, index |
      event_presented_by[index] = presented_by.text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
    end

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

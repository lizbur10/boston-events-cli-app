class BostonEvents::Event
  attr_accessor :name, :dates, :sponsor, :venue, :deal_url, :website_url, :category
  @@all = []

  def self.all
    @@all
  end

  def save
    @@all << self if !self.class.all.detect { | saved_event | saved_event.name == self.name }
  end

  def self.list_events(scraper, category)
    if category.events.length == 0
      puts "Retrieving event information..."
#      scraper = BostonEvents::Scraper.new(category)
      scraper.launch_event_scrape(category)
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

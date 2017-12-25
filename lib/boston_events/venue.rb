class BostonEvents::Venue

  attr_accessor :name, :events

  @@all = []

  def self.all
    @@all
  end

  def self.create_by_name(name)
    venue = self.new
    venue.name = name
    venue.events = []
    @@all << venue
    venue
  end

  def self.find_or_create_by_name(name)
    self.all.detect { | venue | venue.name == name } || create_by_name(name)
  end

end

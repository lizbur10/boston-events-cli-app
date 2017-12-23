class BostonEvents::Sponsor
  attr_accessor :name, :events

  @@all = []

  def self.all
    @@all
  end

  def self.create_by_name(name)
    sponsor = self.new
    sponsor.name = name
    sponsor.events = []
    @@all << sponsor
    sponsor
  end

  def self.find_or_create_by_name(name)
    @@all.detect { | sponsor | sponsor.name == name } || create_by_name(name)
  end

end

class BostonEvents::Category

  attr_accessor :name, :url, :events

  @@all = []

  def self.all
    @@all
  end

  def self.create_by_name(name, url)
    category = self.new
    category.url = url
    category.name = name
    category.events = []
    self.all << category
    category
  end

  def self.find_or_create_by_name(name, url)
    self.all.detect { | category | category.url == url } || create_by_name(name, url)
  end

end

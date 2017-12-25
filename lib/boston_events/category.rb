class BostonEvents::Category
  
  attr_accessor :name, :events

  @@all = []

  def self.all
    @@all
  end

  def self.create_by_name(name)
    category = self.new
    category.name = name
    category.events = []
    @@all << category
    category
  end

  def self.find_or_create_by_name(name)
    @@all.detect { | category | category.name == name } || create_by_name(name)
  end

end

class BostonEvents::Category

  def self.list_events(category)
    puts "return events in the selected category"
    # BostonEvents::Event.list_events(category)
    BostonEvents::Event.list_events   #will add category in later
    
  end

end

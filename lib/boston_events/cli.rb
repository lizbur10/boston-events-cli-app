# CLI Controller
class BostonEvents::CLI

  def call
    menu
    # list_events
    goodbye
  end

  def menu
    puts "What's going on in Boston"
    puts "Select a category or type exit:"
    list_categories
    input = nil
    while input != "exit"
      input = gets.strip.downcase
      if input == "1"
        # @events = BostonEvents::Event.list_events("stage")
        @events = BostonEvents::Event.scrape_stage_events
      elsif input == "2"
        @events = BostonEvents::Category.list_events("music")
      elsif input == "3"
        @events = BostonEvents::Category.list_events("art")
      elsif input == "4"
        @events = BostonEvents::Category.list_events("kids")
      elsif input == "5"
        @events = BostonEvents::Category.list_events("top_ten")
      elsif input == "exit"
        return
      else
        puts "I'm not sure what you want - please enter a category number or type exit"
        call
      end
    end
  end

  def list_categories
    puts "1. Stage"
    puts "2. Music"
    puts "3. Art"
    puts "4. Kids"
    puts "5. Top Ten"
  end

  def puts_events
    @events.each { | event | puts "#{event.name} - #{event.dates} - #{event.presented_by}" }
  end

  def goodbye
    puts
    puts "Thanks for stopping by -- come back often to check out what's going on around town!"
  end
end

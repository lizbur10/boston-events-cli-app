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
        @events = BostonEvents::Event.list_events("stage")
      elsif input == "2"
        @events = BostonEvents::Event.list_events("music")
      elsif input == "3"
        @events = BostonEvents::Event.list_events("art")
      elsif input == "4"
        @events = BostonEvents::Event.list_events("kids")
      elsif input == "5"
        @events = BostonEvents::Event.list_events("top-ten")
      elsif input == "exit"
        return
      else
        puts "I'm not sure what you want - please enter a category number or type exit"
        call
      end
      puts_events
    end
  end

  def list_categories
    puts "1. Stage"
    puts "2. Music"
    puts "3. Art"
    puts "4. Kids"
    puts "5. Top Ten"
  end

  def puts_events ## Need to switch this to do it by category instead of @@all
    BostonEvents::Event.all.each.with_index(1) do | event, index |
      ##need to implement category info here
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.presented_by}"
    end
  end

  def goodbye
    puts
    puts "Thanks for stopping by -- come back often to check out what's going on around town!"
  end
end

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
      case input
      when "1"
        category = "stage"
      when "2"
        category = "music"
      when "3"
        category = "art"
      when "4"
        category = "kids"
      when "5"
        category = "top-ten"
      when "exit"
        return
      else
        puts "I'm not sure what you want - please enter a category number or type exit"
        call
      end
      @events = BostonEvents::Event.list_events(category)
      puts_events(category)
    end
  end

  def list_categories
    puts "1. Stage"
    puts "2. Music"
    puts "3. Art"
    puts "4. Kids"
    puts "5. Top Ten"
  end

  def puts_events(category)
    BostonEvents::Category.all.each do | event |
      ##need to implement category info here
      i = 0
      if event.category == category
        i += 1
        puts "#{i}. #{event.name}, #{event.dates}, presented by #{event.presented_by}"
      end
    end
  end

  def goodbye
    puts
    puts "Thanks for stopping by -- come back often to check out what's going on around town!"
  end
end

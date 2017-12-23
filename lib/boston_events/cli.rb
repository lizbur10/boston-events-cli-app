# CLI Controller
class BostonEvents::CLI

  def call
    menu
    # list_events
    goodbye
  end

  def menu
    puts "What's going on in Boston"
    puts "Select a category by number or type exit"
    list_categories
    input = nil
    while input != "exit"
      input = gets.strip.downcase
      case input
      when "1"
        category_name = "stage"
      when "2"
        category_name = "music"
      when "3"
        category_name = "art"
      when "4"
        category_name = "kids"
      when "5"
        category_name = "top-ten"
      when "exit"
        return
      else ## Something's not working right here -- typed 6, got message & reload, typed exit and it printed top ten 
        puts "I'm not sure what you want - please enter a category number or type exit"
        call
      end
      category = BostonEvents::Category.find_or_create_by_name(category_name)
      BostonEvents::Event.list_events(category)
      puts_events(category)
    end
  end

  def list_categories
    puts "1. Stage"
    puts "2. Music"
    puts "3. Art"
    puts "4. Kids"
    puts "5. Top Ten"
    puts "6. All events (not yet implemented)"
  end

  def puts_events(category)
    puts
    puts "Events in category: #{category.name.capitalize}"
    category.events.each.with_index(1) do | event, index |
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.sponsor}"
    end
  end

  def goodbye
    puts
    puts "Thanks for stopping by -- come back often to check out what's going on around town!"
  end
end

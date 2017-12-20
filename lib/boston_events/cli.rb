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
        @events = list_events("stage")
      elsif input == "2"
        @events = list_events("music")
      elsif input == "3"
        @events = list_events("art")
      elsif input == "4"
        @events = list_events("kids")
      elsif input == "5"
        @events = list_events("top_ten")
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

  def list_events(category)
    puts <<-DOC
      1. A Christmas Celtic Sojourn with Brian O'Donovan in... - Presented by WGBH - Dec 14 - 22
      2. She Loves Me - Presented by Greater Boston Stage Company - Nov 24 - Dec 23
    DOC
  end

  def goodbye
    puts
    puts "Thanks for stopping by -- come back often to check out what's going on around town!"
  end
end

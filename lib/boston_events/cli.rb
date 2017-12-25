# CLI Controller
class BostonEvents::CLI
  attr_accessor :category

  def call
    puts; puts
    puts "Hi! Welcome to the Boston Events Finder -- your BEF friend in the Boston area!"
    puts "You can quit this app at any time by typing exit."
    puts; puts "Start by selecting a category:"
    input = nil
    while input != "exit"
      category = select_category
      BostonEvents::Event.list_events(category)
      list_events_in_category(category)
    end #while
  end

  def select_category
    puts_categories
      input = gets.strip.downcase
      case input
      when "1"
        category_name = "stage"
      when "2"
        category_name = "music"
      when "3"
        category_name = "art"
      when "4"
        category_name = "culture"
      when "5"
        category_name = "kids"
      when "6"
        category_name = "top-ten"
      when "exit"
        abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
      else
        puts "I'm not sure what you want - please enter a category number or type exit"
        select_category
      end # Case statement
      BostonEvents::Category.find_or_create_by_name(category_name)
    # end # While
  end # #select_category

  def puts_categories
    puts "1. Stage"
    puts "2. Music"
    puts "3. Art"
    puts "4. Culture"
    puts "5. Kids"
    puts "6. Top Ten"
  end # #list_categories

  def list_events_in_category(category)
    puts; puts "Here's what's happening in the #{category.name.capitalize} category:"
    puts
    category.events.each.with_index(1) do | event, index |
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.sponsor.name}"
    end #each
    puts; puts "Select an event to see more information or type 'list' to return to the category list."
    choose_event_to_view(category)
  end # #list_events_in_category

  def choose_event_to_view(category)
    input = nil
    while input != 'exit'
      input = gets.strip.downcase
      if input.to_i >= 1 && input.to_i <= category.events.length
        return_event_info(category, input)
      elsif input == "list"
        call
      elsif input == "exit"
        abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
      else
        puts "I'm not sure what you want - please enter a number between 1 and #{category.events.length} or type list."
      end # if/elsif/else
    end
  end

  def return_event_info(category, input)
    category.events.detect.with_index(1) do | event, index |
      if input.to_i == index
        puts_event_info(event)
      end
    end # detect
    puts; puts "Select another event or type 'list' to return to the category list."
  end

  def puts_event_info(event)
    puts; puts "OK, here are the details:"
    puts; puts "#{event.name}"
    puts "Date(s): #{event.dates}"
    puts "Presented by #{event.sponsor.name}"
    puts "Venue: #{event.venue.name}"
    puts "Event website: #{event.website_url}" if event.website_url
    puts "Check Here for Deals: #{event.deal_url}" if event.deal_url
  end

end # Class

# CLI Controller
class BostonEvents::CLI
  attr_accessor :category

  def call
    puts; puts
    puts "Hi! Welcome to the Boston Events Finder -- your BEF friend in the Boston area!"
    puts "You can quit this app at any time by typing exit."
    puts; puts "Start by selecting a category:"
    input = nil
    scraper = BostonEvents::Scraper.new
    while input != "exit"
      category = select_category(scraper)
      BostonEvents::Event.list_events(category)
      list_events_in_category(scraper, category)
    end #while
  end

  def select_category(scraper)
    scraper.categories == nil ? scraper.scrape_categories : scraper.categories
    scraper.categories[:labels].each.with_index(1) do | label, index |
      puts "#{index}. #{label}"
    end
    puts "#{scraper.categories[:labels].length + 1}. Top Ten"

    input = gets.strip.downcase
    scraper.categories[:labels].each.with_index(1) do | label, index |
      if input.to_i == index
        category = BostonEvents::Category.find_or_create_by_name(label)
      elsif input == "exit"
        abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
      else
        puts "I'm not sure what you want - please enter a category number or type exit"
        select_category(scraper)
      end # if/elsif/else
    end # each
    category
  end # #select_category

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
    # puts; puts "Would you like to see more info?" if event.website_url
    # input = gets.strip.downcase
    # if ( input == "yes" || input == "y" )
    #   open_in_browser(event.website_url)
    # else
    #   ##do something else
    # end
  end

  # def open_in_browser(url)
  #   system("open '#{url}'")
  # end

end # Class

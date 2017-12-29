To Do:

1. DONE - Add venue functionality - coded but needs to be checked
2. DONE - Add sponsor functionality
3. DONE - "More info" functionality - coded but needs to be checked
4. DONE - Update CLI to work with 'More Info' functionality
5. DONE (for now) - Refactor CLI
6. DONE - Work on UI of CLI
7. DONE - REFACTOR EVENTS! create hash for scrape selectors? - Done except for list_events method
8. DONE - Create README
9. Release gem (http://guides.rubygems.org/publishing/) - can't get this to work; keep getting  access denied
10. DONE - Add explanations for each item in spec.md
11. DONE - Create video demo
12. DONE - Finish blog post
13. DONE - Refactor to include Scraper class
14. DONE - Refactor to scrape categories
15. DONE - Add "retrieving events" message while scrape is happening
16. DONE - Make doc a class variable

Questions
1. long URLs that wrap are broken
2. Access denied error when trying to publish the gem
3. Instructions for Installation/Usage/Development on README

Future additions (?)
* Add "list by venue" functionality to CLI
* Add "list all" functionality to CLI
* Add "More info?" for events -> open in browser window if yes


Error handling for 404 error

MAX_ATTEMPTS = 10

doc = nil
begin
  doc = Nokogiri::HTML(open(url).read.strip)
rescue Exception => ex
  log.error "Error: #{ex}"
  attempts = attempts + 1
  retry if(attempts < MAX_ATTEMPTS)
end

if(doc.nil?)
  puts "Sorry - the website is not responding. Please try again later."
else
  [continue with scrape code]
end

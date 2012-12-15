require 'shelfari'
require 'rss/maker'
require 'json'

TITLE = "Example Title"
LINK = "http://www.example.com/Link"
DESCRIPTION = "Example Description"
USERNAME = "ExampleUserName"


content = RSS::Maker.make("2.0") do |m|
  m.channel.title = TITLE
  m.channel.link = LINK
  m.channel.description = DESCRIPTION
  m.items.do_sort = true
  
  shelf = Shelfari.new
  now_reading = JSON.parse(shelf.now_reading(USERNAME))
  now_reading["books"].each do |raw_book|
    book = JSON.parse(shelf.book(raw_book["bookId"]))[0]
    i = m.items.new_item
    i.title = book["title"]
    i.link = book["url"]
    i.date = Time.now
    i.description = "I am now reading #{book["title"]} by #{book["author"]}"
  end
end

puts content 
    


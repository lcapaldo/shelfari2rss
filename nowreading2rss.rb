require 'shelfari'
require 'rss/maker'
require 'json'

TITLE = "Example Title"
LINK = "http://www.example.com/Link"
DESCRIPTION = "Example Description"
USERNAME = "ExampleUserName"
OUTPUTFILE = "example.xml"
HISTORICALINFO = "example.json"

bookinfo = {}

if File.exist? HISTORICALINFO
  bookinfo = JSON.parse(File.read(HISTORICALINFO))
end

shelf = Shelfari.new

now_reading = JSON.parse(shelf.now_reading(USERNAME))
now_reading["books"].each do |raw_book|
  book_id = raw_book["bookId"]
  unless bookinfo.has_key? book_id.to_s
    bookinfo[book_id.to_s] = Time.now.to_i
  end
end

File.open(HISTORICALINFO, "w") { |f| f.puts  JSON.generate(bookinfo) }
  



content = RSS::Maker.make("2.0") do |m|
  m.channel.title = TITLE
  m.channel.link = LINK
  m.channel.description = DESCRIPTION
  m.items.do_sort = true
  
  bookinfo.each do |k, v|
    book = JSON.parse(shelf.book(k.to_i))[0]
    i = m.items.new_item
    i.title = book["title"]
    i.link = book["url"]
    i.date = Time.at(v)
    i.description = "I am now reading #{book["title"]} by #{book["author"]}"
  end
end

File.open(OUTPUTFILE, "w") { |f| f.puts content }

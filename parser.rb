require 'nokogiri'
require 'time'
require 'sequel'
require 'open-uri'
DB = Sequel.connect File.read('database.conf').strip

class GitStream

  def update_atom atom_xml
    d = Nokogiri::XML.parse atom_xml
    d.search('entry').map {|e|
      item = {
        update_id: e.at('id').inner_text,
        author: e.at('name').inner_text,
        date: Time.parse(e.at('published').inner_text), # .strftime("%b %d %I:%M%p"), 
        title: e.at('title').inner_text,
        content: e.at('content').inner_text,
        media: e.xpath('media:thumbnail',{'media'=>"http://search.yahoo.com/mrss/"}).first[:url]
      }
      if DB[:updates].first update_id:item[:update_id]
        # we can break since the rest of the items will have been seen
        next
      else
        DB[:updates].insert item
        item[:title]
      end
    }.compact
  end

  def update_list programmers
    programmers.select {|p| p =~ /\w+/}.each {|programmer|
      programmer.chomp!
      print programmer
      cmd  = "curl -sL 'https://github.com/#{programmer}.atom'"
      atom_xml = `#{cmd}`
      new = update_atom atom_xml
      pred = new.size > 0 ? " -> #{new.size} new items" : ''
      print pred
      print "\n"
    }
  end
    
end

if __FILE__ == $0
  g = GitStream.new
  g.update_list File.readlines('programmers.txt')

end

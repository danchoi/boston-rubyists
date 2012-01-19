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
      unless DB[:updates].first update_id:item[:update_id]
        DB[:updates].insert item
        item[:title]
      end
    }.compact
  end

  def update_list programmers
    programmers.select {|p| p =~ /\w+/}.each {|programmer|
      puts programmer.chomp!
      cmd  = "curl -sL 'https://github.com/#{programmer}.atom'"
      atom_xml = `#{cmd}`
      new = update_atom atom_xml
      puts "#{new.size} new items"
    }
  end
    
end

if __FILE__ == $0
  g = GitStream.new
  g.update_list File.readlines('programmers.txt')

end

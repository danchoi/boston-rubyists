require 'nokogiri'

# curl 'https://github.com/search?type=Users&language=ruby&q=location:cambridge%2Bma'  > search.sample.xml

class SearchResults
end


def SearchResults.run(city, state)
  url =  "https://github.com/search?type=Users&language=ruby&q=location:#{city}%2B#{state}"
  fetch_parse url
end

def SearchResults.fetch_parse url
  html = `curl -s '#{url}'`
  parse html
end

def SearchResults.parse html
  doc = Nokogiri::HTML html
  doc.search("h2.title a").each {|a|
    puts a.inner_text
  }
  if (span = doc.at(".pagination .current")) && (nextpage = span.xpath("./following-sibling::*")[0])
    SearchResults.fetch_parse nextpage[:href]
  end
end


if __FILE__ == $0
  s = SearchResults.run *ARGV
end

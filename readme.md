# gogoanime

gogoanime is a gem for scraping data from gogoanime.io

## Installation


```bash
gem install gogoanime
```

## Usage

```ruby
require 'gogoanime'

g = Gogoanime::Scraper.new

g.recent()
# => [{:image_url=>"...", :title=>"...", :episode_url=>"...", :episode=>1, :anime_path=>"..."}, ...]

g.anime('naruto')
#=> {:title=>"Naruto", :type=>"TV Series", :summary=>"...", :genre=>["Action", "Comedy", "Martial Arts", "Shounen", "Super Power"], :released=>2002, :status=>"Completed", :other_names=>["ナルト"], :image_url=>"...", :episodes=>"220"}

g.episode('naruto', 1)
#=> {:title=>"Naruto Episode 1 English Subbed", :category=>"TV Series", :info=>"Naruto", :number=>1, :sources=>[...]}

g.search('naruto')
#=>
#{:image_url=>"...", :title=>"Naruto", :released=>2002}
#{:image_url=>"...", :title=>"Naruto (Dub)", :released=>2002}
#{:image_url=>"...", :title=>"Naruto Shippuden", :released=>2007}

g.autocomplete('naruto')
#=>
#{:image_url=>"...", :path=>"naruto", :title=>"Naruto"}
#{:image_url=>"...", :path=>"naruto-dub", :title=>"Naruto (Dub)"}
#{:image_url=>"...", :path=>"naruto-shippuden", :title=>"Naruto Shippuden"}
```

## Contributing
Pull requests are welcome.

## TODO
* add multiple page support
* fix japanese encoding
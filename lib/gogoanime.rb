require 'open-uri'
require 'nokogiri'
require 'json'

module Gogoanime
    class scraper
        def recent(pages=1)
            document = fetch(BASE_URL)
            result = []
            document.css('ul.items li').each do |item|
                a = item.css('a')[0]
                result << {
                    image_url:   item.css('img')[0]['src'],
                    title:       a['title'],
                    episode_url: a['href'],
                    episode:     item.css('p.episode').text.split(' ').last.to_i,
                    anime_path:  a['href'].split('-episode-').first
                }
            end
            return result
        end

        def anime(path)
            document = fetch(File.join(BASE_URL, 'category' , path))
            t = document.css('p.type')
            return {
                title:       document.css('h1').text,
                type:        t[0].css('a')[0].text,
                summary:     t[1].text[14..-1],
                genre:       t[2].css('a').map { |a| a = a.text.gsub(',', '').strip },
                released:    t[3].text[10..-1].to_i,
                status:      t[4].text[8..-1],
                other_names: t[5].text.split(': ')[1..-1].join.split(', '),
                image_url:   document.css('div.anime_info_body_bg img')[0]['src'],
                episodes:    document.css('ul#episode_page li').last.css('a')[0]['ep_end']
            }
        end

        def episode(path, number)
            document = fetch(File.join(BASE_URL, "#{path}-episode-#{number}"))
            result = {
                title:      document.css('div.title_name h2')[0].text,
                category:   document.css('div.anime_video_body_cate a')[0].text,
                info:       document.css('div.anime-info a')[0].text,
                number:     number,
                sources:    []
            }
            for link in document.css('div.anime_muti_link ul li a').map { |a| a = a['data-video']}

                result[:sources] << (link.start_with?('http') ? link : File.join('https://', link))

            end

            return result
        end

        def search(str)
            document = fetch(File.join(BASE_URL, "search.html?keyword=#{str.downcase}"))
            results = []
            for item in document.css('ul.items li')
                results << {
                    image_url: item.css('div.img a img')[0]['src'],
                    title:     item.css('p.name a')[0].text,
                    released:  item.css('p.released')[0].text.split(':').last.strip.to_i
                }
            end
            return results
        end

        def autocomplete(str)
            document = open("https://ajax.gogocdn.net/site/loadAjaxSearch?keyword=#{str.downcase.gsub(' ', '+')}").read
            document = Nokogiri::HTML(JSON.parse(document)['content'])
            results = []
            for item in document.css('div.list_search_ajax') do
                a = item.css('a')[0]
                results << {
                    image_url:  item.css('div.thumbnail-recent_search')[0]['style'].split(': url("').last[0..-3],
                    path:       a['href'].split('/').last,
                    title:      a.text
                }
            end
            return results
        end

        private

        BASE_URL = "https://www.gogoanime.io/"

        def fetch(url)
            return Nokogiri::HTML(open(url).read)
        end
    end
end
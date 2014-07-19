require_relative 'TresbienScraper'

task :scrape_task => :environment do
	TresbienScraper.new("http://tres-bien.com/categories/outerwear/", "Outerwear")
	#TresbienScraper.new("http://tres-bien.com/categories/trousers/", "Bottoms")
end
require_relative 'SsenseScraper'
require_relative 'TresbienScraper'
require_relative 'MrPorterScraper'

task :scrape_task => :environment do
	MrPorterScraper.new("http://www.mrporter.com/Shop/Clothing/Suits", "Suits")
	#SsenseScraper.new("https://www.ssense.com/men/designers/all/clothing/suits-blazers/suits", "Suits")
	#TresbienScraper.new("http://tres-bien.com/categories/outerwear/", "Outerwear")
	#TresbienScraper.new("http://tres-bien.com/categories/trousers/", "Bottoms")
end


task :scrape_mrporter => :environment do
  mrporter = MrPorterScraper.new
  mrporter.begin_scrape("http://www.mrporter.com/Shop/Clothing/Suits")
end
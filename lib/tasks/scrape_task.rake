require_relative 'SsenseScraper'
require_relative 'TresbienScraper'
require_relative 'MrPorterScraper'

task :scrape_all => :environment do
	MrPorterScraper.new("http://www.mrporter.com/Shop/Clothing/Suits", "Suits")
	SsenseScraper.new("https://www.ssense.com/men/designers/all/clothing/suits-blazers/suits", "Suits")

	TresbienScraper.new("http://tres-bien.com/categories/outerwear/", "Outerwear")
	#TresbienScraper.new("http://tres-bien.com/categories/trousers/", "Bottoms")
end

task :scrape_mrporter, [:url, :category, :is_test] => :environment do |task, args|
  args.with_defaults(url: "http://www.mrporter.com/Shop/Clothing/Suits", category: "Suits", is_test: true)
  mrporter = MrPorterScraper.new
  mrporter.begin_scrape(args.url, args.category, args.is_test)
end

task :scrape_ssense, [:url, :category, :is_test] => :environment do |task, args|
  args.with_defaults(url: "https://www.ssense.com/men/designers/all/clothing/suits-blazers/suits", category: "Suits", is_test: true)
  ssense = SsenseScraper.new
  ssense.begin_scrape(args.url, args.category, args.is_test)
end

task :scrape_tresbien, [:url, :category, :is_test] => :environment do |task, args|
  args.with_defaults(url: "http://tres-bien.com/categories/outerwear/", category: "Outerwear", is_test: true)
  tresbien = TresbienScraper.new
  tresbien.begin_scrape(args.url, args.category, args.is_test)
end
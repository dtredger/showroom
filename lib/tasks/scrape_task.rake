require_relative 'TresbienScraper'

task :scrape_test => :environment do
	TresbienScraper.new("http://tres-bien.com/categories/outerwear/", "Outerwear")
end
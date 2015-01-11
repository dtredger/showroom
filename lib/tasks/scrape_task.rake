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


task new_scrape_tresbien: :environment do
  ssense = SiteScraper.new(
      store_name: "Ssense",
      # index page selectors
      index_item_group_selector: "li.rect",
        index_product_name_selector: "h2.product-name",
        index_designer_selector: "",
        index_category_selector: "",
        index_product_link_selector: "a",
        index_price_cents_selector: ".regular-price",
      # detail page selectors
      detail_product_name_selector: "",
      detail_description_selector: "",
      detail_designer_selector: ".product-designer",
      detail_price_cents_selector: ".product-price",
      detail_currency_selector: "",
      detail_image_source_selector: "",
      detail_category_selector: ""
  )
  ssense.scrape_index("SOME_URL", true)

end
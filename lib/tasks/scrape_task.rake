require_relative 'SsenseScraper'
require_relative 'MrPorterScraper'

task :scrape_all => :environment do
	MrPorterScraper.new("http://www.mrporter.com/Shop/Clothing/Suits", "Suits")
end


task :scrape_mrporter, [:url, :category, :is_test] => :environment do |task, args|
  args.with_defaults(url: "http://www.mrporter.com/Shop/Clothing/Suits", category: "Suits", is_test: true)
  mrporter = MrPorterScraper.new
  mrporter.begin_scrape(args.url, args.category, args.is_test)
end

task scrape_ssense: :environment do
  url = "https://www.ssense.com/men/designers/all/clothing/suits-blazers/suits"
  scraper = SiteScraper.where(store_name:"tresbien").first
  if scraper.blank?
    scraper = SiteScraper.new(
        store_name: "ssense",
        # index page selectors
        index_item_group_selector: ".browsing-product-item",
        index_product_name_selector: "h4.product-name",
        index_designer_selector: ".product-designer",
        index_category_selector: "",
        index_product_link_selector: "a",
        index_price_cents_selector: '', #".product-price",
        # detail page selectors
        detail_product_name_selector: "",
        detail_description_selector: "",
        detail_designer_selector: ".product-designer",
        detail_price_cents_selector: ".css('.product-price').text.strip.split(" ").last",
        detail_currency_selector: "",
        detail_image_source_selector: "",
        detail_category_selector: ""
    )
  end
  scraper.scrape_index(url)
end



task scrape_tresbien: :environment do
  url = "http://tres-bien.com/categories/outerwear/"
  category = "Outerwear"
  scraper = SiteScraper.where(store_name:"tresbien").first
  if scraper.blank?
    scraper = SiteScraper.new(
        store_name: "tresbien",
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
  end
  scraper.scrape_index(url)
end
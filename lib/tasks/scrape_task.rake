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
        index_price_cents_selector: '', #".css('.product-price').text.strip.split(' ').last",
        # detail page selectors
        detail_product_name_selector: ".product-name",
        detail_description_selector: ".product-description-hider.product-description",
        detail_designer_selector: ".product-brand",
        detail_price_cents_selector: ".product-price",
        detail_currency_selector: "", #.product-price.split(" ").last
        detail_image_source_selector: ".product-thumbnail",
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
        index_item_group_selector: "at_css('li.rect')",
        index_product_name_selector: "at_css('h2.product-name').text.strip",
        index_designer_selector: "",
        index_category_selector: "",
        index_product_link_selector: ".at_css('a')[:href]",
        index_price_cents_selector: "at_css('.regular-price').text",
        # detail page selectors
        detail_product_name_selector: "",
        detail_description_selector: "",
        detail_designer_selector: "at_css('.product-designer')",
          # TODO - should be new- and old-price selectors
          detail_price_cents_selector: "at_css('.special-price .price')",
          # old_price: "at_css('.old-price .price')",
        detail_currency_selector: "",
        detail_image_source_selector: "css('img').first['data-src']",
        detail_category_selector: ""
    )
  end
  scraper.scrape_index(url)
end
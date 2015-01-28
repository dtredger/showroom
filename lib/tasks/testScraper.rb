test_scraper = SiteScraper.new(
    store_name: "test",
    page_urls: Rails.root.join("spec/factories/store_scrapes/tres_bien_outerwear.html").to_s,
    index_item_group_selector: "css('li.rect')",
    index_product_name_selector: "at_css('h2.product-name').text.strip",
    index_designer_selector: "",
    index_category_selector: "",
    index_product_link_selector: "at_css('a')[:href]",
    index_price_cents_selector: "css('span').text.strip.split(' ').last",
    # detail page selectors
    detail_product_name_selector: "",
    detail_description_selector: "",
    detail_designer_selector: "at_css('.product-designer')",
    # TODO - should be new- and old-price selectors
    detail_price_cents_selector: "at_css('.special-price .price').text.strip",
    # old_price: "at_css('.old-price .price')",
    detail_currency_selector: "",
    detail_image_source_selector: "at_css('.action-image-active')[:src]",
    detail_category_selector: ""
)
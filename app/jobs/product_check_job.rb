class ProductCheckJob < ActiveJob::Base
  queue_as :daily_live_product_check

  def perform(store_name)
    price_changed = []
    unchanged = []
    errors = []

    scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first
    selector = scraper[:detail_price_cents_selector]
    items = Item.where(store_name: store_name).where(state: "live")

    items.each do |item|
      result = item.check_price(selector)
      if result.first == :price_change
        price_changed << results.last
      elsif result.first == :unchanged
        unchanged << results.last
      else
        errors << results.last
      end
    end

    [ price_changed, unchanged, errors ]

  end





end

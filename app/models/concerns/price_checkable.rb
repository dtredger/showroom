module PriceCheckable
  extend ActiveSupport::Concern

  include Scrapeable

  def check_price(selector)

    log = Logger.new 'log/product_check.log'
    item = self
    begin
      page = open_url(item[:product_link])
      new_price = eval("page.#{selector}")
      new_price_cents = price_to_cents(new_price)
      if item[:price_cents] != new_price_cents
        item.update(price_cents: new_price_cents)
        result = [:price_change, item.id]
      else
        item.update(updated_at: Time.now)
        result = [:unchanged, item.id]
      end
    rescue Exception => e
      log.error "price_check error: #{e}"
      item.update(state: "retired")
      result = [:error, item.id]
    end
    result
  end


end


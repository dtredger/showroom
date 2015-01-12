class ProductCheckJob < ActiveJob::Base
  queue_as :daily_live_product_check

  def perform(*args)
    # state 1 is live (friendly_finder for where not set up)
    errors = []

    Item.all.live.each do |item|
      begin
        item_link = Net::HTTP.get(URI.parse(item.product_link))
        if item_link
          item.update(updated_at: Time.now)
        else
          item.update(state: "retired")
        end
      rescue Exception => e
        errors << e
        item.update(state: "retired")
      end
    end
    errors
  end


end

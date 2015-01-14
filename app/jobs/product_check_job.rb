class ProductCheckJob

  LOG = Logger.new 'log/resque.log'

  def self.perform(store_name)
    LOG.debug "SELF"
    begin
      price_changed = []
      unchanged = []
      errors = []

      scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first
      selector = scraper[:detail_price_cents_selector]
      items = Item.live.where(store_name: store_name)

      items.each do |item|
        result = item.check_price(selector)
        if result.first == :price_change
          price_changed << result.last
        elsif result.first == :unchanged
          unchanged << result.last
        else
          errors << result.last
        end
      end
      LOG.debug "seems to work..."
      LOG.debug [ price_changed, unchanged, errors ]
      [ price_changed, unchanged, errors ]
    rescue Exception => e
      LOG.debug e
    end
  end


end

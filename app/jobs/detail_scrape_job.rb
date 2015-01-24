class DetailScrapeJob

  DETAIL_SCRAPE_LOGGER = Logger.new 'log/detail_scrape.log'

  def self.perform(store_name)
    items = Item.incomplete.where(store_name: store_name)
    scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first

    success = []
    errors = []
    items.each do |item|
      begin
        success << SiteScraper.scrape_detail_page(scraper, item)
      rescue Exception => e
        errors << e
      end
    end
    DETAIL_SCRAPE_LOGGER.info "successes:"
    DETAIL_SCRAPE_LOGGER.info success
    DETAIL_SCRAPE_LOGGER.error "errors"
    DETAIL_SCRAPE_LOGGER.error errors
  end

end


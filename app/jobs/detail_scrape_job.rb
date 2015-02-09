class DetailScrapeJob

  DETAIL_SCRAPE_LOGGER = if ENV["DETAIL_SCRAPE_LOGGER"].present?
                           Logger.new(ENV["DETAIL_SCRAPE_LOGGER"])
                         else
                           Logger.new(STDOUT)
                         end

  def self.perform(store_name)
    DETAIL_SCRAPE_LOGGER.info "ran at #{Time.now}"
    DETAIL_SCRAPE_LOGGER.info "store_name:  #{store_name}"

    items = Item.incomplete.where(store_name: store_name)
    scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first

    successes = []
    no_image = []
    not_updated = []
    errors = []
    items.each do |item|
      DETAIL_SCRAPE_LOGGER.info "scraping: #{item.id}"
      begin
        result = SiteScraper.scrape_detail_page(scraper, item)
        case result.first
          when :success
            successes << result.second
          when :no_image
            no_image << result.second
          when :not_updated
            not_updated << result.second
        end
      rescue Exception => e
        DETAIL_SCRAPE_LOGGER.error e.message
        errors << [item.id, e.message]
      end
    end
    DETAIL_SCRAPE_LOGGER.info "successes: #{successes}"
    DETAIL_SCRAPE_LOGGER.info "no_image: #{no_image}"
    DETAIL_SCRAPE_LOGGER.info "not_updated: #{not_updated}"
    DETAIL_SCRAPE_LOGGER.error "errors: #{errors}"
    DETAIL_SCRAPE_LOGGER "-----------------------------------"
  end

end


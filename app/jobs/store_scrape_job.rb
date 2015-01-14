class StoreScrapeJob

  STORE_SCRAPE_LOGGER = Logger.new 'log/store_scrape.log'

  def self.perform(store_name)
    # TODO - temporary
    page_url = "http://tres-bien.com/categories/outerwear/"

    STORE_SCRAPE_LOGGER.debug "ran at #{Time.now}"
    scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first
    result = scraper.scrape_index(page_url)

    STORE_SCRAPE_LOGGER.debug "results_log:"
    STORE_SCRAPE_LOGGER.debug result[0]
    STORE_SCRAPE_LOGGER.debug "success_log:"
    STORE_SCRAPE_LOGGER.debug result[1]
    STORE_SCRAPE_LOGGER.debug "errors_log:"
    STORE_SCRAPE_LOGGER.debug result[2]
  end

end
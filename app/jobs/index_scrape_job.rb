class IndexScrapeJob

  INDEX_SCRAPE_LOGGER = Logger.new 'log/index_scrape.log'

  def self.perform(store_name)
    INDEX_SCRAPE_LOGGER.info "ran at #{Time.now}"
    INDEX_SCRAPE_LOGGER.info "store_name: #{store_name}"

    begin
      scraper = SiteScraper.where(store_name: store_name).order('updated_at DESC').first
      scraper.page_urls.each do |page_url|
        INDEX_SCRAPE_LOGGER.info "scraping #{page_url}"
        result = scraper.scrape_index(page_url)

        result.each do |key, val|
          INDEX_SCRAPE_LOGGER.info "#{key} - #{val}"
        end
      end

    rescue Exception => e
      INDEX_SCRAPE_LOGGER.error e
    end

  end

end
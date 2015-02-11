class IndexScrapeJob

  INDEX_SCRAPE_LOGGER = if ENV["INDEX_SCRAPE_LOGGER"].present?
                          Logger.new(ENV["INDEX_SCRAPE_LOGGER"])
                        else
                          Logger.new(STDOUT)
                        end

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

    total_job_info = [successes, no_image, not_updated, errors]
    AdminMailer.jobs_notifier(AdminUser.on_notification_list, total_job_info).deliver_later

  end

end
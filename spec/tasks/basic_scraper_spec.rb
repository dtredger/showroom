require 'rspec'
require 'rails_helper'
require 'rake'

Dir[Rails.root.join('lib/tasks/*.rb')].each { |f| require f }

RSpec.describe 'Basic Scraper' do

  # let(:rake) { Rake::Application.new }

  # before do
  #   load "tasks/scrape_task.rake"
  #   Rake::Task.define_task(:environment)
  # end


  #
  # it 'should do something' do
  #   MrPorterScraper.stub initialize: cats
  #
  #   # allow(MrPorterScraper).to receive(open_url)
  #   # allow(MrPorterScraper).to receive(resize_image)
  #   # allow(MrPorterScraper).to receive(format_item_to_local_url_path)
  #   Rake::Task["scrape_task"].invoke
  #   binding.pry
  #   expect(@cats).to eq('yup')
  #   # expect{ Rake::Task["scrape_task"].invoke}.to change{ Items.count}
  # end


  it "is cool" do
    expect(true).to eq(true)
  end


  it "loads urls" do
    basic_scraper = BasicScraper.allocate
    site = basic_scraper.open_url('https://www.google.ca')

    expect(site.class).to eq(Nokogiri::HTML::Document)
  end

end
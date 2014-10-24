require 'rspec'
require 'rails_helper'
require 'rake'


RSpec.describe 'Basic Scraper' do

  let(:rake) { Rake::Application.new }

  before do
    load "tasks/scrape_task.rake"
    Rake::Task.define_task(:environment)
  end

  def cats:
    cats
  end

  it 'should do something' do
    MrPorterScraper.stub initialize: cats

    # allow(MrPorterScraper).to receive(open_url)
    # allow(MrPorterScraper).to receive(resize_image)
    # allow(MrPorterScraper).to receive(format_item_to_local_url_path)
    Rake::Task["scrape_task"].invoke
    binding.pry
    expect(@cats).to eq('yup')
    # expect{ Rake::Task["scrape_task"].invoke}.to change{ Items.count}
  end


end
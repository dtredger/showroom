require 'rspec'
require 'rails_helper'
require 'rake'


RSpec.describe 'Basic Scraper' do

  let(:rake) { Rake::Application.new }

  before do
    load "tasks/scrape_task.rake"
    Rake::Task.define_task(:environment)
  end

  it 'should do something' do
    expect{ Rake::Task["scrape_task"].invoke}.to change{ Items.count}
  end


end
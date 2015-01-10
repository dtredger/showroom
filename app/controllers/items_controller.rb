class ItemsController < ApplicationController

  before_filter :item_live?, only: [:show]


  def index
    @closets_item = ClosetsItem.new
    @items = handle_search.where(state: 1).includes(:images).page(params[:page]).per(27)
  end

  def show
    @closets_item = ClosetsItem.new
    @item = Item.friendly.find(params[:id])
    @like = @item.likes.build
    respond_to do |format|
      format.html
      format.js { render file: "items/show" }
    end
  end


  private

  def value_to_cents(amount_value)
    return 0 unless amount_value.respond_to?(:to_money)
    money = amount_value.to_money
    money.cents
  end

  def handle_search
    # http://www.justinweiss.com/blog/2014/02/17/search-and-filter-rails-models-without-bloating-your-controller/
    # http://stackoverflow.com/questions/14219528/activerecord-anonymous-scope
    items = Item.where(nil) # creates an anonymous scope
    items = items.search_designer(params[:designer]) unless params[:designer].blank?
    items = items.search_category1(params[:category1]) unless params[:category1].blank?
    items = items.search_min_price(value_to_cents(params[:min_price])) unless params[:min_price].blank?
    items = items.search_max_price(value_to_cents(params[:max_price])) unless params[:max_price].blank?
    items
  end

  def item_live?
    redirect_to(root_path) if Item.where(state:1).find_by_slug(params[:id]).nil?
  end

end
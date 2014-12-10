class ItemsController < ApplicationController

  def index
    @closets_item = ClosetsItem.new()
    @items = handle_search
    # Allow state when items are approved
    #@items = @items.where(state: 1).page(params[:page]).per_page(27)#.order("created_at DESC") -- default scope should handle this
    #@items = @items.page(params[:page]).per_page(27)#.order("created_at DESC") -- default scope should handle this
    @items = @items.page(params[:page]).per(9)
  end

  def show
    @closets_item = ClosetsItem.new()
    @item = Item.find(params[:id])
    @like = @item.likes.build
  end

  #
  # Items are imported through the scraper
  #
  # def new
  # end

  def create
  end

  def edit
  end

  def update
  end


  def delete
  end

  def edit_multiple
    @items = Item.find(params[:item_ids])
  end

  def update_multiple
    @items = Item.update(params[:items].keys, params[:items].values)
    @items.reject! { |i| i.errors.empty? }
    if @items.empty?
      redirect_to :root
    else
      render "index"
    end
  end

  private

  def value_to_cents(amount_value)
    return 0 unless amount_value.respond_to?(:to_money)
    money = amount_value.to_money
    money.cents
  end

  # Add state to search (only display active items)
  def handle_search
    # http://www.justinweiss.com/blog/2014/02/17/search-and-filter-rails-models-without-bloating-your-controller/
    # http://stackoverflow.com/questions/14219528/activerecord-anonymous-scope

    items = Item.where(nil) # creates an anonymous scope
    items = items.search_designer(params[:designer]) unless params[:designer].blank?
    items = items.search_category1(params[:category1]) unless params[:category1].blank?
    items = items.search_min_price(value_to_cents(params[:min_price])) unless params[:min_price].blank?
    items = items.search_max_price(value_to_cents(params[:max_price])) unless params[:max_price].blank?
    return items
  end

end
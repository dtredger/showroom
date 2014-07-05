# Copied from Showroom

class ItemsController < ApplicationController

  def index
    @ci = ClosetsItem.new()
    if params.any?
      @items = handle_search
      @items = @items.order("product_name").page(params[:page]).per_page(27)
    else
      @items = Item.all.order("product_name").page(params[:page]).per_page(27)
    end

  end

  def show
    @item = Item.find(params[:id])
    @like = @item.likes.build
  end

  def new
  end

  def create
    # @closet = Closet.find(params[:id])
  end

  def edit
  end

  def update
  end


  def delete
  end


  private

  def value_to_cents(amount_value)
    return 0 unless amount_value.respond_to?(:to_money)
    money = amount_value.to_money
    money.cents
  end

  def handle_search
    min_price = params[:min_price]
    max_price = params[:max_price]

    products = Item.all
    products = products.where("designer LIKE ?", "%#{params[:designer]}%") if !params[:designer].blank?
    products = products.where("category1 LIKE ?", "%#{params[:category1]}%") if !params[:category1].blank?
    products = products.where("price_cents >= ?", value_to_cents(min_price)) if !min_price.blank? && min_price.respond_to?(:to_money)
    products = products.where("price_cents <= ?", value_to_cents(max_price)) if !max_price.blank? && max_price.respond_to?(:to_money)
    return products
  end

end
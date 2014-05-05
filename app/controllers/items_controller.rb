# Copied from Showroom

class ItemsController < ApplicationController

  def index
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

  def handle_search
    products = Item.all
    products = products.where("designer LIKE ?", "%#{params[:designer]}%") if !params[:designer].blank?
    products = products.where("category1 LIKE ?", "%#{params[:category1]}%") if !params[:category1].blank?
    products = products.where("price >= ?", params[:min_price]) if !params[:min_price].blank?
    products = products.where("price <= ?", params[:max_price]) if !params[:max_price].blank?
    return products
  end

end
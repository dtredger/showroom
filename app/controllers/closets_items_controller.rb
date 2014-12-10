class ClosetsItemsController < ApplicationController

	def create
		@closets_item = ClosetsItem.new(closet_item_params)
    respond_to do |format|
      if @closets_item.save
        # stays on page, and runs views/closets_items/create.js.erb
        format.js
      else
        redirect_to @item, notice: "Error adding item to closet."
      end
    end
	end

	def destroy
		closet_item = current_user.closets.find(params[:closet_id]).items.find(params[:item_id])
		if closet_item.destroy
			redirect_to :back, notice: "Deleted item from closet."
			#flash[:notice] = "Deleted item from closet!"
		else
			redirect_to :back
			flash[:notice] = "Error deleting item from closet."
		end
	end


	private

	def closet_item_params
		params.require(:closets_item).permit(:closet_id, :item_id)
	end

end
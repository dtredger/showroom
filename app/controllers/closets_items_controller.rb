class ClosetsItemsController < ApplicationController

	def new
		@item_id = params[:item_id]
		@closets_item = ClosetsItem.new
		respond_to do |format|
			# format.html
			format.js { render file: "closets_items/new" }
		end
	end

	def create
		@closets_item = ClosetsItem.new(closet_item_params)
      if @closets_item.save
				respond_to do |format|
        # stays on page, and runs views/closets_items/create.js.erb
        	format.js  { render file: "closets_items/create" }
					# format.html { redirect_to root_path, notice: "Item added." }
				end
			else
				respond_to do |format|
					# stays on page, and runs views/closets_items/create.js.erb
					format.js  { render partial: "layouts/errors" }
					# format.html { }
				end
        #TODO must be updated, especially with item-uniqueness requirement

      end
    # end
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
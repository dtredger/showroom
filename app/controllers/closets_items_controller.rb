class ClosetsItemsController < ApplicationController

	def create
		@closet = current_user.closets(params[:closets_item])
		@closets_item = ClosetsItem.new(closet_item_params)

		if @closets_item.save
			redirect_to root_path, notice: "Added to your closet"
		else
			redirect_to @item, notice: "fail"
		end
	end

	def destroy
		binding.pry

		current_user.closets.find(params[:closet_id]).items.delete(params[:item_id])
		redirect_to :back


		# @closet_item = ClosetsItem.where("closet_id = ? AND item_id = ?", params[:closet_id], params[:item_id]).first
		# binding.pry
		# if @closet_item.destroy
		# 	redirect_to :back, confirm: "Are you sure?"
		# 	flash[:notice] = "It's gone..."
		# else
		# 	render 'show', notice: "Something is the matter"
		# end
	end

	private

		def closet_item_params
			params.require(:closets_item).permit(:closet_id, :item_id)
		end
end
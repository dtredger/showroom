class ClosetsController < ApplicationController

	#
	# Controls items in the closet, not the closet itself.
	#

	def index
		@closets = current_user.closets
	end

	def show
		@closet = Closet.find(params[:id])
	end

	def new
		@closet = Closet.new
	end


	def create
		@closet = Closet.new(list_params)
		@closet.user_id = current_user.id
		if @closet.save
			redirect_to user_path(current_user), notice: "Created a closet. Start shopping."
		else
			render 'new', notice: "Something went terribly wrong..."
		end
	end

	def edit
		@closet = Closet.find(params[:id])
	end

	def update
		@closet = Closet.find(list_params)

		if @closet.update_attributes(list_params)
			redirect_to user_path, notice: "Closet updated."
		else
			render 'edit', alert: "Something went wrong. Again..."
		end
	end

	def destroy
		@closet = Closet.find(params[:id])

		if @closet.destroy
			redirect_to user_path(current_user)
			flash.now[:notice] = "It's gone..."
		else
			render 'show', notice: "Something is the matter"
		end
	end


	private

		def list_params
			params.require(:closet).permit(:list_name, :title, :summary, :user_id)
		end

end


class ClosetsController < ApplicationController
  before_filter :correct_user, only: [:show]

	def index
    if current_user
		  @closets = current_user.closets
    else
      redirect_to new_user_session_path
    end
	end

	def show
		@closet = Closet.includes(:items).where(id: params[:id]).first

	end

	def new
		@closet = Closet.new
	end

	def create
		@closet = current_user.closets.build(list_params)
		if @closet.save
			redirect_to closets_path, notice: "Created a new closet."
		else
			render 'new', notice: "Error creating closet."
		end
	end

	def edit
		@closet = current_user.closets.find(params[:id])
	end

	def update
		@closet = current_user.closets.find(params[:id])

		if @closet.update_attributes(list_params)
			redirect_to closet_path(@closet), notice: "Closet updated."
		else
			render 'edit', alert: "Something went wrong. Again..."
		end
	end

	def destroy
		@closet = current_user.closets.find(params[:id])

		if @closet.destroy
			redirect_to closets_path, notice: 'Deleted closet.'
		else
			render 'show', notice: "Error deleting closet"
		end
	end


	private

	def list_params
		params.require(:closet).permit(:title, :summary)
  end

  def correct_user
    if current_user.nil?
      redirect_to new_user_session_path
    elsif Closet.where(user_id: current_user.id).where(id: params[:id]).to_a == []
      redirect_to closets_path
    end
  end

end


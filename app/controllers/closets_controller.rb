class ClosetsController < ApplicationController
  before_filter :authenticated_user
  before_filter :correct_closet, only: [:show, :destroy]

	def index
    @closets = current_user.closets
	end

	def show(modal=false)
		@closet = Closet.includes(:items).where(id: params[:id]).first
	end

	def new(modal=false)
		@closet = Closet.new
		respond_to do |format|
			format.html
			format.js { render 'closets/new' }
		end
	end

	def create
		@closet = current_user.closets.build(closet_params)
		if @closet.save
			redirect_to closets_path, notice: "Created a new closet."
    else
      flash_errors(@closet)
			render :new
		end
  end

	def edit
		@closet = current_user.closets.find(params[:id])
	end

	def update
		@closet = current_user.closets.find(params[:id])
		if @closet.update_attributes(closet_params)
			redirect_to closet_path(@closet), notice: "Closet updated."
    else
      flash_errors(@closet)
			render 'edit'
		end
	end

	def destroy
		@closet = current_user.closets.find(params[:id])
		if @closet.destroy
			redirect_to closets_path, notice: 'Deleted closet.'
    else
      flash_errors(@closet)
			render 'show'
		end
	end


	private

	def closet_params
		params.require(:closet).permit(:title, :summary)
  end

  def correct_closet
    if Closet.where(user_id: current_user.id).where(id: params[:id]).to_a == []
      redirect_to closets_path
    end
  end

end


class ClosetsController < ApplicationController
  before_filter :correct_user
  before_filter :correct_closet, only: [:show]

	def index
    if current_user.nil?
      redirect_to new_user_session_path
    else
      @closets = current_user.closets
    end
	end

	def show
    # TODO - this seems more complex than necessary
		@closet = Closet.includes(:items).where(id: params[:id]).first
	end

	def new
		@closet = Closet.new
	end

	def create
		@closet = current_user.closets.build(closet_params)
		if @closet.save
			redirect_to closets_path, notice: "Created a new closet."
    else
      flash_errors(@closet)
			render 'new'
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

  def correct_user
    if current_user.nil?
      redirect_to new_user_session_path
    end
  end

  def correct_closet
    if Closet.where(user_id: current_user.id).where(id: params[:id]).to_a == []
      redirect_to closets_path
    end
  end

  def flash_errors(resource)
    resource.errors.full_messages.each do |message|
      flash[:alert] = message
    end
  end

end


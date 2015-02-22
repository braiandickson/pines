class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
	before_action :authenticate_user!, except: [:index, :show, :search]
	before_action :find_pin, :only => [:show, :edit, :update, :destroy]
	before_action :check_auth, :only => [:edit, :update, :destroy]

	def search
		if params[:search].present?
			@pins = Pin.search(params[:search])
		else
			@pins = Pin.all.order("created_at DESC")
		end
	end

	def check_auth
		if session[:user_id] != @pin.user_id
			flash[:notice] = "No tienes autorizacion para realizar esa accion"
			redirect_to pins_path
		end
	end

	def index
		@pins = Pin.all.order("created_at DESC")
	end

	def new
		@pin = current_user.pins.build
	end

	def create
		@pin = current_user.pins.build(pin_params)

		if @pin.save
			redirect_to @pin, notice: "Succefully created new Pin"
		else
			render 'new'
		end
	end

	def show
	end

	def edit
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was Succefully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@pin.destroy
		redirect_to root_path
	end

	def upvote
		@pin.upvote_by current_user
		redirect_to :back
	end

	private

	def pin_params
		params.require(:pin).permit(:title, :description, :image)
	end

	def find_pin
		@pin = Pin.find(params[:id])
	end
end

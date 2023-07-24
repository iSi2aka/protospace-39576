class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show]

  def index
    @user = current_user
    @prototypes = Prototype.includes(:user) 
  end

  def new
    @prototype = Prototype.new
  end
  
  def create 
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    end 
  end

  def show
    #@user = User.find(user_params)
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end 

  def edit
    unless current_user.id == @prototype.user_id 
      redirect_to root_path
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    prototype.update(prototype_params)
    if prototype.save
      redirect_to root_path
    end
  end 

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end 

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end 

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

end


class CommentsController < ApplicationController
  
  def new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if @comment.save
      redirect_to root_path, :notice => "New status posted!"
    else
      redirect_to root_path, :notice => "Error, could not post new comment"
    end
  end
  
end
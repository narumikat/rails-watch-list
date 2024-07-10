class ReviewsController < ApplicationController
  before_action :set_list

  def new
    @review = Review.new
  end

  def create
    @review = @list.reviews.build(review_params)
    if @review.save
      redirect_to @list
    else 
      puts @review.errors.full_messages
      render :new
    end
  end

  def destroy
    @review = @list.reviews.find(params[:id])
    @review.destroy
    redirect_to @list
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end

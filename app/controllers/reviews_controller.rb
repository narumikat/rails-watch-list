class ReviewsController < ApplicationController
  before_action :set_movie

  def new
    @review = Review.new
  end

  def create
    @review = @movie.review.build(review_params)
    if @review.save
      redirect_to @movie
    else 
      render :new
    end
  end

  def destroy
    @review = @movie.reviews.find(params[:id])
    @review.destroy
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end

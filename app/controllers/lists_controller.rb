class ListsController < ApplicationController
  # before_action :set_latest_lists, only: [:home, :index, :show, :new, :create]

  def home
    @lists = List.includes(bookmarks: { movie: :reviews })
    @latest_reviews = Review.order(created_at: :desc).limit(6)
    @latest_two_lists = List.order(created_at: :desc).limit(2)
  end

  def index
    @lists = List.all
  end
  
  def show
    @list = List.find(params[:id])
    @movies = @list.movies
    @bookmarks = @list.bookmarks
    @bookmark = Bookmark.new
    @available_movies = Movie.where.not(id: @list.movies.pluck(:id))
    @review = Review.new
    @reviews = @list.reviews.order(created_at: :desc)
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  private

  def list_params
    params.require(:list).permit(:name, :image_url, :photo)
  end
end

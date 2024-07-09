class MoviesController < ApplicationController
  # before_action :set_latest_lists, only: [:show]

  def show
    @movie = Movie.find(params[:id])
    @lists = @movie.lists
    @available_lists = List.where.not(id: @movie.lists.pluck(:id))
    @bookmark = Bookmark.new
    
  end
end

class SearchController < ApplicationController
  # before_action :set_latest_lists, only: [:index]

  def index
    @query = params[:query]
    @movies = Movie.where('title ILIKE ?', "%#{@query}%")
    @lists = List.where('name ILIKE ?', "%#{@query}%")
  end
end

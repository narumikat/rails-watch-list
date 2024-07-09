class BookmarksController < ApplicationController
  def create
    if params[:list_id]
      @list = List.find(params[:list_id])
      @bookmark = @list.bookmarks.build(bookmark_params)
    else
      @bookmark = Bookmark.new(bookmark_params)
    end

    if @bookmark.save
      redirect_to redirect_path_after_create(@bookmark)
    else
      render_new_page_with_errors
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), notice: 'Bookmark was successfully deleted.'
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :list_id, :comment)
  end

  def redirect_path_after_create(bookmark)
    if params[:list_id]
      list_path(bookmark.list)
    else
      movie_path(bookmark.movie)
    end
  end

  def render_new_page_with_errors
    if params[:list_id]
      @list = List.find(params[:list_id])
      render 'lists/show'
    else
      @movie = @bookmark.movie
      @available_lists = List.where.not(id: @movie.lists.pluck(:id))
      render 'movies/show'
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :set_latest_lists

  private

  def set_latest_lists
    @latest_lists = List.order(created_at: :desc).limit(6)
  end
end

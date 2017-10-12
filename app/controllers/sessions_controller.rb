class SessionsController < ApplicationController

  def create
    session.clear
    session[:state] = params[:state]
    session[:code] = params[:code]
    redirect_to dashboard_path
  end

end

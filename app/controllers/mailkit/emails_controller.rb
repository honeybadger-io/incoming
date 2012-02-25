class Mailkit::EmailsController < ApplicationController
  protect_from_forgery :except => :create 

  def create
    if @result = receiver_class.receive(request)
      render :json => {:status => 'ok'}
    else
      render :json => {:status => 'rejected'}
    end
  end

  protected
  def receiver_class
    params[:receiver].classify.constantize
  end
end

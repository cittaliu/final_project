require 'rubygems'
require 'httparty'

class UsersController < ApplicationController

  before_action :authorize, only: [:dashboard]

  include HTTParty
  format :json

  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      UserMailer.welcome_email(user).deliver
      session[:user_id] = user.id
      redirect_to '/dashboard'
    else
      redirect_to '/signup'
    end
  end

  def dashboard
    @user = current_user

    read_calendar

  end

  def read_calendar

    # @options = {query: {host: 'api.cronofy.com'}, Authorization: 'Bearer xoTQMfDkfJM19CBoBXIMFh4DKvUnDJlR'}
    #
    # params = 'https://api.cronofy.com/v1/events?tzid=Etc/UTC'
    # # p params

    @cronofy = Cronofy::Client.new(access_token: "xoTQMfDkfJM19CBoBXIMFh4DKvUnDJlR")

    @events = @cronofy.read_events

    # response = self.class.get(
    #   params
    # )

    require 'json'
    # data = @events.to_json
    # # p data

    @events.each do |item|
      @summary = item['summary']
      @start = item['start']
      @end_date = item['end']
      p @summary
      p @start
      p @end_date
    end

    # @summaries = data[0]['summary']
    # p @summaries
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end

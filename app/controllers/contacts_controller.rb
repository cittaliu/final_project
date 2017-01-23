class ContactsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @company = Company.find_by_id(params[:id])
  end

  def create
    @company = Company.find_by_id(params[:id])

    @contacts = @company.contacts
  end
end

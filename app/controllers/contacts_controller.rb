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
    @company.contacts.create(contact_params)
    redirect_to opportunities_path
  end


  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name)
  end

end

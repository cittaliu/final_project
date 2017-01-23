class UsercontactsController < ApplicationController

    def index
    end

    def show
    end

    def new
      @company = Company.find_by_id(params[:id])
    end

    def create
      p "Create contacts called"
      @company = Company.find_by_id(params[:id])
      @company.contacts.create(contact_params)
      @user = current_user
      @user.contacts << @company.contacts.last
      p @user.usercontacts
    end


    @company.openings.create(opening_params)
    @user = current_user
    @user.openings << @company.openings.last
    redirect_to opportunities_path(current_user)



    @company = Company.find_by_id(params[:id])
    @company.openings.create(opening_params)
    @user = current_user
    @user.openings << @company.openings.last


    private

    def contact_params
      params.require(:usercontact).permit(:first_name, :last_name)
    end


end

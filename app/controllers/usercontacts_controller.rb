class UsercontactsController < ApplicationController

    def index
    end

    def show
    end

    def new
      @company = Company.find_by_id(params[:id])
    end

    def create
      @company = Company.find_by_id(params[:id])
      @company.contacts.create(contact_params)
      @user = current_user
      @user.contacts << @company.contacts.last

      redirect_to opportunities_path
    end

    private

    def contact_params
      params.require(:contact).permit(:first_name, :last_name)
    end

end

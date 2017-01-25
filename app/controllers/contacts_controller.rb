class ContactsController < ApplicationController

  autocomplete :contact, :first_name

  def index
    # @contacts= []
    @contacts = User.find_by_id(current_user.id).contacts
    # @all_contacts.each do |contact|
    #   if contact.
    # end

    if params[:search]
     @contacts = Contact.first_name_like("%#{params[:search]}%").order('first_name')
    end

    respond_to do |format|
    format.html
    format.json { @contacts = Contact.search(params[:term]) }
    end
  end

  def show
    @contact = Contact.find_by_id(params[:contact_id])
    @task = @contact.usercontacts.new
    # adding new usercontact
    @user = User.find_by_id(params[:id])
  end

  def new
    @company = Company.find_by_id(params[:id])
  end

  def update

  end


  private

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email)
  end

end

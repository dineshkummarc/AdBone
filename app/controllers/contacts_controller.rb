class ContactsController < ApplicationController

  respond_to :json

  rescue_from ActiveRecord::RecordInvalid do
    respond_with @contact, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do
    respond_with @contact, status: :not_found
  end

  def index
    respond_with Contact.all
  end

  def show
    begin
      @contact = Contact.find params[:id]
      respond_with @contact
    rescue Exception => e
      respond_with nil, :status => :not_found
    end
  end

  def create
    @contact = Contact.new params.delete_if{ |p| ["controller","action"].include? p }
    if @contact.save
      respond_with @contact, :status => :created, :location => @contact
    else
      respond_with @contact, :status => :unprocessable_entity
    end
  end

  def update
    @contact = Contact.find params[:id]
    @contact.update_attributes! params.delete_if{ |p| ["controller", "action", "id"].include? p }
    respond_with @contact, status: :ok
  end

  def destroy
    begin
      @contact = Contact.find params[:id]
      @contact.destroy
      head :ok
    rescue Exception => e
      respond_with nil, :status => :not_found
    end
  end

end

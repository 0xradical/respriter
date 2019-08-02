class ContactUsController < ApplicationController
  def new; end

  def create
    respond_to do |format|
      # format.html
      format.json do
        contact = Contact.new(contact_params)

        if contact.save
          render json: { status: :ok }
        else
          render json: { status: :unprocessable_entity, reason: :validation }
        end
      end
    end
  end

  protected

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end

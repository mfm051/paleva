class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(owner)
    :new_restaurant
  end
end

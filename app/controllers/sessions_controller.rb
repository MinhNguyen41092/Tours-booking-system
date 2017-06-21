class SessionsController < Devise::SessionsController
  respond_to :html, :js

  def create
    self.resource = warden.authenticate(auth_options)
    if resource && resource.active_for_authentication?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end

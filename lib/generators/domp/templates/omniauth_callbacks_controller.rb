<% module_namespacing do -%>
class <%= class_name.pluralize %>::OmniauthCallbacksController < Devise::OmniauthCallbacksController

<% providers.each do |provider| -%>
  def <%= provider.underscore %>
    create
  end

<% end -%>
  private

    def create
      auth_params = request.env["omniauth.auth"]
      provider = AuthenticationProvider.where(name: auth_params.provider).first
      email_matching_user = User.where('email = ?', auth_params['info']['email']).first
      authentication = provider.<%= class_name.downcase %>_authentications.where(uid: auth_params.uid).first
      if authentication
        sign_in_with_existing_authentication(authentication)
      elsif <%= class_name.downcase %>_signed_in?
        create_authentication_and_sign_in(auth_params, current_<%= class_name.downcase %>, provider)
      elsif !<%= class_name.downcase %>_signed_in? and email_matching_user
        create_authentication_and_sign_in(auth_params, email_matching_user, provider)         
      else
        create_<%= class_name.downcase %>_and_authentication_and_sign_in(auth_params, provider)
      end
    end

    def sign_in_with_existing_authentication(authentication)
      sign_in_and_redirect(:<%= class_name.downcase %>, authentication.<%= class_name.downcase %>)
    end

    def create_authentication_and_sign_in(auth_params, <%= class_name.downcase %>, provider)
      <%= class_name %>Authentication.create_from_omniauth(auth_params, <%= class_name.downcase %>, provider)

      sign_in_and_redirect(:<%= class_name.downcase %>, <%= class_name.downcase %>)
    end

    def create_<%= class_name.downcase %>_and_authentication_and_sign_in(auth_params, provider)
      <%= class_name.downcase %> = <%= class_name %>.create_from_omniauth(auth_params)
      if <%= class_name.downcase %>.valid?
        create_authentication_and_sign_in(auth_params, <%= class_name.downcase %>, provider)
      else
        flash[:error] = <%= class_name.downcase %>.errors.full_messages.first
        redirect_to new_<%= class_name.downcase %>_registration_url
      end
    end
end
<% end -%>
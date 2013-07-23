<% module_namespacing do -%>
class <%= class_name %>Authentication < ActiveRecord::Base
  belongs_to :<%= class_name.downcase %>
  belongs_to :authentication_provider

  serialize :params

<% if Rails::VERSION::MAJOR < 4 -%>
  attr_accessible "#{class_name.downcase}_id", :authentication_provider_id, :uid, :token, :token_expires_at, :params

<% end -%>
  def self.create_from_omniauth(params, <%= class_name.downcase %>, provider)
    create(
      <%= class_name.downcase %>: <%= class_name.downcase %>,
      authentication_provider: provider,
      uid: params['uid'],
      token: params['credentials']['token'],
      token_expires_at: Time.at(params['credentials']['expires_at']).to_datetime,
      params: params,
    )
  end
end
<% end -%>
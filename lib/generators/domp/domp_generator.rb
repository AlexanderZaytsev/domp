require 'bundler'
class DompGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  argument :providers, type: :array, banner: "provider"

  def check_if_devise_is_installed
    unless File.exists?("config/initializers/devise.rb")
      puts "Devise not found. Install it first."
      exit
    end
  end

  def check_if_devise_has_generated_model
    unless File.exists?("app/models/#{file_name}.rb")
      puts "Could not find `app/models/#{file_name}.rb`. You need to generate it with Devise first."
      exit
    end
  end

  def update_devise_config
    omniauth_config = []

    providers.each do |provider|
      id = ask("#{provider.capitalize} application ID:")
      secret = ask("#{provider.capitalize} application secret:")
      omniauth_config << "\n  config.omniauth :#{provider.underscore}, '#{id}', '#{secret}'\n"
    end

    inject_into_file 'config/initializers/devise.rb', after: "# config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'" do
      omniauth_config.join('')
    end
  end

  def update_model_class
    inject_into_class "app/models/#{file_name}.rb", class_name do
      "  has_many :authentications, class_name: '#{class_name}Authentication', dependent: :destroy\n"
    end

    inject_into_class "app/models/#{file_name}.rb", class_name do
      <<-METHOD.gsub(/^ {6}/, '')
        def self.create_from_omniauth(params)
          attributes = {
            email: params['info']['email'],
            password: Devise.friendly_token
          }

          create(attributes)
        end

      METHOD
    end

    inject_into_file "app/models/#{file_name}.rb", after: "  devise" do
      " :omniauthable,"
    end
  end

  def update_gemfile
    gem 'omniauth'
    providers.each do |provider|
      gem "omniauth-#{provider}"
    end
  end

  def update_routes
    inject_into_file 'config/routes.rb', after: "devise_for :#{table_name}" do
      ", controllers: { omniauth_callbacks: '#{table_name}/omniauth_callbacks' }"
    end
  end

  def copy_templates
    template 'authentication_provider.rb', 'app/models/authentication_provider.rb'
    template "model_authentication.rb", "app/models/#{file_name}_authentication.rb"
    template "authentication_providers_migration.rb", "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_authentication_providers.rb"
    template "model_authentications_migration.rb", "db/migrate/#{(Time.now + 1).strftime('%Y%m%d%H%M%S')}_create_#{class_name.downcase}_authentications.rb"
    template "omniauth_callbacks_controller.rb", "app/controllers/#{table_name}/omniauth_callbacks_controller.rb"
  end

  def bundle
    Bundler.with_clean_env do
      run 'bundle install'
    end
  end

  def migrate
    rake 'db:migrate'
  end

end

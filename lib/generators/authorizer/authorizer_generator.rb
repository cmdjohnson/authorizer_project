class AuthorizerGenerator < Rails::Generator::Base
  def manifest
    file_name = generate_file_name
    @migration_name = file_name.camelize
    record do |m|
      m.migration_template "authorizer_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => file_name
    end
  end

  private

  def generate_file_name
    "create_object_roles"
  end

end

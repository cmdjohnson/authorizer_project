class AuthorizerGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.migration_template 'migration:migration.rb', "db/migrate", {:assigns => my_assigns,
        :migration_file_name => filename
      }
    end
  end

  private
  #  def custom_file_name
  #    custom_name = class_name.underscore.downcase
  #    custom_name = custom_name.pluralize if ActiveRecord::Base.pluralize_table_names
  #  end

  def filename
    "create_object_roles"
  end

  def table_name
    "object_roles"
  end

  def my_assigns
    returning(assigns = {}) do
      assigns[:migration_action] = "create"
      assigns[:class_name] = filename
      assigns[:table_name] = table_name
      assigns[:attributes] = [Rails::Generator::GeneratedAttribute.new("klazz_name", "string")]
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("object_reference", "integer")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("user", "references")
      assigns[:attributes] << Rails::Generator::GeneratedAttribute.new("role", "string")
    end
  end
end
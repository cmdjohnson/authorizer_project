class CreateObjectRoles < ActiveRecord::Migration
  def self.up
    create_table :object_roles do |t|
      t.string :class_name
      t.integer :object_reference
      t.references :user
      t.string :role
      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :object_roles
  end
end
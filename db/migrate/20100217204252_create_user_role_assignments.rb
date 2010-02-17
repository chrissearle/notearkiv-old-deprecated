class CreateUserRoleAssignments < ActiveRecord::Migration
  def self.up
    create_table :user_role_assignments do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_role_assignments
  end
end
 
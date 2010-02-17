class User < ActiveRecord::Base
  acts_as_authentic

  has_many :user_role_assignments
  has_many :roles, :through => :user_role_assignments

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.logged_in_timeout(30.minutes)
  end

  has_many :user_role_assignments
  has_many :roles, :through => :user_role_assignments

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end
end

# coding: UTF-8

class Role < ActiveRecord::Base
  has_many :user_role_assignments
  has_many :users, :through => :user_role_assignments
end

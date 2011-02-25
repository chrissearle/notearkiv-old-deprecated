# coding: UTF-8

class UserRoleAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
end

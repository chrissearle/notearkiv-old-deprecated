# coding: UTF-8

require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  fixtures :users

  it "should generate a one time code" do
    user = User.find(:first)

    code = user.one_time_code

    code.should be_true(code.size == 40)
  end

  it "should send a message" do
    arkiv = mock(Arkiv)

    user = User.find(:first)

    user.clear_one_time_code

    user.send_reset_password

    user.onetime.should_not be_nil
  end

end
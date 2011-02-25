# coding: UTF-8

require File.dirname(__FILE__) + '/../spec_helper'

describe Note do
  fixtures :notes

  it "should suggest voices" do
    voices = Note.suggest_voice("ss")

    voices.size.should == 2

    voices.each { |voice| voice.should be_true(voice.starts_with? "SS") }
  end
end
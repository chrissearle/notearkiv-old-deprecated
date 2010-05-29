require File.dirname(__FILE__) + '/../spec_helper'

describe Note do
  fixtures :notes

  it "should suggest voices" do
    voices = Note.suggest_voice("ss")

    voices.should be_an_instance_of(String)
    voices.should include("SSATB")
    voices.should include("SSAAT")
    voices.should_not include("SATBB")
    voices.should_not include("SATTBBB")
  end

  it "should generate a new item id" do
    Note.next_item.should == 6
  end
end
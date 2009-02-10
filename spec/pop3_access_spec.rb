#!/usr/local/bin/ruby
modules_path = File.join('lib','modules')
module_files = Dir["#{modules_path}/*.bmm_mod.rb"]
module_files.each { |modFile| require modFile }
require 'net/pop'

include Backup::Mail

describe PopAccount do
  
  before(:each) do
    @account = PopAccount.new({
      :server   => "pop.gmail.com",
      :email    => "joshholt.testaccount@gmail.com",
      :username => "joshholt.testaccount@gmail.com",
      :port     => 995,
      :ssl      => true
    })
  end
  
  describe "When Incorrect Information is given" do
    it "should not be authenticated" do
      @account.password = "InvalidPassword"
      @account.should_not be_authenticated
    end
  end
  
  describe "When Correct Information is given" do
    it "should be authenticated" do
      @account.password = "I$tanB00L"
      @account.should be_authenticated
    end
  end
end
#
# pop3_access_spec.rb
#
# @Author Josh Holt
# @Date 	02.10.2009
#
#	@Purpose --> This spec file will test the pop3 access with the provided info
#******************************************************************************

require File.join("./","mail_backup.rb")

describe BackupMyMail do
  
  before(:each) do
    @account = BackupMyMail.new({
      :server   => "pop.gmail.com",
      :email    => "joshholt.testaccount@gmail.com",
      :username => "joshholt.testaccount@gmail.com",
      :password => "I$tanB00L",
      :port     => 995,
      :ssl      => true
    })
  end
  
  describe "When incorrect login information is given" do
    it "should not be authenticated" do
      @account.password = "InvalidPassword"
      @account.should_not be_authenticated
    end
  end
  
  
  describe "When incorrect server information is given" do
  	it "should not be authenticated" do
  		@account.server = "popper.gmail.com"
  		@account.should_not be_authenticated
  	end
  end
  
  describe "When incorrect port is given" do
  	it "should not be authenticated" do
  		@account.port = 996
  		@account.should_not be_authenticated
  	end
  end
  
  describe "When SSL is required and port is 110" do
  	it "should not be authenticated" do
  		@account.ssl  = true
  		@account.port = 110
  		@account.should_not be_authenticated
  	end
  end
  
  describe "When all account information is correct" do
  	it "should be authenticated" do
  		@account.should be_authenticated
  	end
  end
end

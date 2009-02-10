#!/usr/local/bin/ruby
#	pop3_access.bmm_mod.rb
#       
#	@Author Josh Holt
# @Date 02.09.2009
#
# @purpose --> The purpose of this module is to access a pop3 email
#            account. Fetch the new emails and store them in a unique
#            folder.
#***********************************************************************       


########################################################################
# Requires The net/pop std library -------------------------------------
########################################################################

require 'net/pop'
require 'openssl'

#************* Begin Module Backup::Mail ******************************#
module Backup
	module Mail
	  class PopAccount
	    attr_accessor :email, :username, :password, :port, :ssl, :server, :backup_dir
	    
	    def initialize(options={})
    	  begin
    	    @email      = options[:email]     if options[:email]
    	    @username   = options[:username]  if options[:username]
    	    @password   = options[:password]  if options[:username]
    	    @port       = options[:port]      if options[:port]
    	    @server     = options[:server]    if options[:server]
    	    @ssl        = options[:ssl]       if options[:ssl]
    	    @backup_dir = File.join(File.dirname(__FILE__),'backups',"#{Time.now.to_f}_#{@email}") if @email
    	  rescue => exception
    	    raise "Insuffcient Parameters to backup your mail! #{exception.message}"
        end
    	end
    	
    	def authenticated?
    	  begin
    	    if @ssl
  				  Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
  				end
  				account = Net::POP3.new(@server,@port)
  				account.auth_only(@username,@password)
    	  rescue Exception => error
    	    false
    	  else
    	    true
    	  end
    	end
	    
  		def fetch_and_store()
  			begin
  			  if @ssl
  				  Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
  				end
  				Net::POP3.start(@server, @port, @username, @password) do |account|
  					if account.mails.empty?
  						puts "There are no new emails in your inbox..."
  					else
  						puts "Downloading emails..."
  						account.each_mail do |message|
  							msg_id = message.unique_id
  							if !File.exists?("#{@backup_dir}")
  							  Dir.mkdir("#{@backup_dir}")
  							end
  							File.open("#{@backup_dir}/#{msg_id}.eml", 'w') do |f|
  								f.write message.pop
  							end # **** End storage
  						end # **** End Loop
  						puts "Successfully downloaded #{account.mails.size} emails"
  					end # **** End Condition
				
  				end #**** End AccountAccess ****
  			rescue => exception
  				raise "The following execption occured: #{exception.message}"
  			end 
		
  		end #**** End FetchAndStore ****
  	end
	end
end
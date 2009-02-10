#!/usr/local/bin/ruby
#	mail_backup.rb
#       
#	Copyright 2009 Josh Holt <jholt@jholt-desktop>
#       
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#       
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#       
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

class BackupMyMail
  attr_accessor :email, :username, :password, :port, :ssl, :server, :backup_dir
  
	modules_path = File.join(File.dirname(__FILE__),'lib','modules')
	module_files = Dir["#{modules_path}/*.mod.rb"]
	module_files.each { |modFile| require modFile }

	if module_files.size > 0
		include Backup::Mail
		include Backup::Mail::ToMbox
	end
	
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
	
	def runBackup()
		Backup::Mail.fetch_and_store()
		squash_emails()
	end
	
	def squash_emails
		files = Dir["#{@backup_dir}/*.eml"]
		files.each do |filename|
			Backup::Mail::ToMbox.CurrentEmail.new(open(filename).readlines).write_archive(@backup_dir)
	  end
	end
	
end


bmy_process  = BackupMyMail.new({
  :server   => "pop.gmail.com",
  :email    => "joshholt.testaccount@gmail.com",
  :username => "joshholt.testaccount@gmail.com",
  :password => "I$tanB00L",
  :port     => 995,
  :ssl      => true
})

bmy_process.runBackup
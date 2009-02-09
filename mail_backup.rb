#!/usr/bin/ruby
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
	modules_path = File.join(File.dirname(__FILE__),'lib','modules')
	module_files = Dir["#{modules_path}/*.mod.rb"]
	module_files.each { |modFile| require modFile }

	if module_files.size > 0
		include Backup::Mail
		include Backup::Mail::ToMbox
	end
	
	def run()
		if Backup::Mail && Backup::Mail::ToMbox
			fetch_and_store()
			parse_emails()
		end
	end
	
end


BackupMyMail.new().run()

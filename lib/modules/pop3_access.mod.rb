#	pop3_access.mod.rb
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

########################################################################
# Requires The net/pop std library -------------------------------------
########################################################################

require 'net/pop'

#************* Begin Module Backup::Mail ******************************#
module Backup
	module Mail
		def fetch_and_store()
			begin
				Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
				Net::POP3.start('pop.gmail.com', 995,
                    'joshholt.testaccount@gmail.com', 'I$tanB00L') do |account|
				
					if account.mails.empty?
						puts "There are no new emails in your inbox..."
					else
						puts "Downloading emails..."
						account.each_mail do |message|
							msg_id = message.unique_id
							File.open("inbox/#{msg_id}", 'w') do |f|
								f.write message.pop
							end # **** End storage
						end # **** End Loop
						puts "Downloaded #{account.mails.size} emails"
					end # **** End Condition
				
				end #**** End AccountAccess ****
			rescue => exception
				raise exception
			end 
		
		end #**** End FetchAndStore ****
	end
end

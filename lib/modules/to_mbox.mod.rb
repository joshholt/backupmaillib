# to_mbox.rb
#     
# Copyright 2009 Josh Holt <jholt@jholt-desktop>
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


module Backup
	module Mail
		module ToMbox
			def make_header(lines)
				from_header = lines.detect { |line| line =~ /^From: / }
				date_header = lines.detect { |line| line =~ /^Date: / }
				if /<(.*)>/.match(from_header)
					sender = $1
				else
					sender = /From: (.*)/.match(from_header)[1]
				end
				dummy, weekday, day, month, year, time = /^Date: (...), ([0-9]*) (...) (....) (........)/.match(date_header).to_a
				if day.length == 1 then day = " " + day end
				"From " + sender + " " + weekday + " " + month + " " + day + " " + time + " " + year
			end

			def dump_multipart(basename, boundary)
				part = 1
				while Dir.entries(".").member?(basename + part.to_s + ".MIME")
					lines = open(basename + part.to_s + ".MIME").readlines
					puts "--" + boundary
					puts escape(lines)
					if Dir.entries(".").member?(basename + part.to_s)
							puts escape(open(basename + part.to_s).readlines)
					end
					if Dir.entries(".").member?(basename + part.to_s + ".1")
							dump_multipart(basename + part.to_s + ".", detect_boundary(lines))
					end
					part += 1
				end
			end

			def detect_boundary(lines)
				boundary_header = lines.detect { |line| line =~ /boundary/ }
				return $1 if /"(.*)"/.match(boundary_header)
			end

			def escape(lines)
				result = []
				lines.each do |line|
					if line =~ /^>*From / then line = ">" + line end
					result.push line
				end
				return result
			end
			
			def parse_emails
				#inbox_path = File.join(File.dirname(__FILE__),'inbox')
				#puts File.dirname(__FILE__)
				files = Dir["inbox/*"]
				files.each do |filename|
					lines = open(filename).readlines
					mbox_file = File.open("inbox.mbox", 'a')  do |f|
						f.write make_header(lines)
						f.write escape(lines)
						f.write("")
					end
				end
			
				#files = files = Dir["inbox/*.HEADER"]
				#files.each do |filename|
				#	lines = open(filename).readlines
				#	mbox_file = File.open("inbox.mbox", 'a')  do |f|
				#		f.write make_header(lines)
				#		f.write escape(lines)
				#		boundary = detect_boundary(lines)
				#		if boundary
				#			f.write dump_multipart(/([0-9]+\.)/.match(filename)[1], boundary)
				#		else
				#			f.write("")
				#		end
				#	end
				#end
				
			end
			
		end
	end
end

require 'json'
require 'fileutils'


sheet_name = gets.chop

json_file_path = "./jsons/#{sheet_name}.json"

dir_path = "./#{sheet_name}_json"
FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)

json_data = open(json_file_path) do |io|
	JSON.load(io)
end

json_data.each do | hash |
	id = hash["id"]
	file_name = "#{dir_path}/" + id.to_s + ".json"

	File.open(file_name, 'w') do |file|
		file.write(hash)
	end

end
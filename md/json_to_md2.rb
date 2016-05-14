require 'mustache'
require 'json'
require 'fileutils'

class Requirements < Mustache
mustache_name = "Requirements"

	#jsonファイルのパスを取得
	Dir::glob("./../jsons/#{mustache_name}_json/*.json").each {|json_file_path|
		#md用のフォルダがなければ作成
		dir_path = Dir::pwd + "/#{mustache_name}_md"
		FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)

		#jsonファイルを開く
		json_data = open(json_file_path) do |io|
		#ハッシュを取り出す
		hash = JSON.load(io)
		
			#ハッシュのキーと値を取得
			hash.each_with_index do | (key, value), i |
				#キーからidを取得してファイル名を作る
				if i == 0
					@file_name = dir_path + "/#{value}.md"
					# if @file_name !~ /^[a-zA-Z]+$/
				end

				File.open(@file_name, 'a') do |file|
					file.puts "###{key}", "#{value}\n\n"
				end

			end
		end
		puts @file_name
	}

end

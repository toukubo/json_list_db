require 'mustache'
require 'json'
require 'fileutils'

mustache_name = "Features"

Mustache.template_file = File.dirname(__FILE__) + "/#{mustache_name}.mustache"
view = Mustache.new

#jsonファイルのパスを取得
Dir::glob("./../jsons/#{mustache_name}_json/*.json").each {|json_file_path|
	#md用のフォルダがなければ作成
	dir_path = Dir::pwd + "/#{mustache_name}_md"
	FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)

	#jsonファイルを開く
	json_data = open(json_file_path) do |io|
	#ハッシュを取り出す
	hash = JSON.load(io)
	
	#mustache用キーが日本語の場合の対策
	count = 1
	
		#ハッシュのキーと値を取得
		hash.each_with_index do | (key, value), i |
			#キーからidを取得してファイル名を作る
			if i == 0
				@file_name = dir_path + "/#{value}.md"
			end

			view[:hash] << {key => value}
			puts view[:hash]
		end
	end
	puts @file_name
	#mdファイル作成
	File.open(@file_name, 'w') do |file|
		file.write(view.render)
	end
}

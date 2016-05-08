require 'mustache'
require 'json'
require 'fileutils'

class Features < Mustache
	mustache_name = Features
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
				#mustache用キーが日本語の場合の対策
				if key !~ /^[a-zA-Z]+$/
					key = "key#{count}"
					count += 1
				end
				@key = []
				@key << key
				#mustache用のメソッド定義
				eval <<-EOS
					def #{key}
						"#{value}"
					end
				EOS
			end
		end
		puts @file_name
		#mdファイル作成
		File.open(@file_name, 'w') do |file|
			file.write(self.render)
		end
		#mustache用のメソッド定義
		i = @key.length
		eval <<-EOS
			until i == 0 do
				undef #{@key[i]}
				p #{@key[i]}
			end
		EOS
	}
end

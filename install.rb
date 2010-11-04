src = "#{Rails.root}/vendor/plugins/mark_it_up/public/mark_it_up"
dest = "#{Rails.root}/public/mark_it_up"
puts "* Copying assets to #{dest}"
FileUtils.cp_r(src, dest)
puts "* Run 'script/generate miu_controller' to generate MarkItUpController and to be able to use default preview parser"

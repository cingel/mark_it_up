class MiuControllerGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  desc "This generator creates the mark it up controller, view and route"

  def create_miucontroller
    copy_file 'app/controllers/mark_it_up_controller.rb', 'app/controllers/mark_it_up_controller.rb'
    copy_file 'app/views/mark_it_up/preview.html.erb', 'app/views/mark_it_up/preview.html.erb'
    add_route
    copy_assets
  end

  private
  def add_route
    preview_route = %{match "mark_it_up/preview" => "mark_it_up#preview"}
    route(preview_route)
  end

  def copy_assets
    src = File.expand_path("../../public/mark_it_up", __FILE__)
    dest = "#{Rails.root}/public/mark_it_up"
    puts "* Copying assets to #{dest}"
    FileUtils.cp_r(src, dest)
  end

end

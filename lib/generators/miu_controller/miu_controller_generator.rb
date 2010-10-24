class MiuControllerGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.file "app/controllers/mark_it_up_controller.rb", "app/controllers/mark_it_up_controller.rb"
      m.directory "app/views/mark_it_up"
      m.file "app/views/mark_it_up/preview.html.erb", "app/views/mark_it_up/preview.html.erb"
      add_route(m)
    end
  end
  
  def add_route(m)
    preview_route = %{
  map.mark_it_up_preview "mark_it_up/preview", :controller => "mark_it_up", :action => "preview"
    }
    m.gsub_file("config/routes.rb", "ActionController::Routing::Routes.draw do |map|", "ActionController::Routing::Routes.draw do |map|#{preview_route}")
  end
  
end
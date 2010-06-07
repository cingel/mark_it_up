class MarkItUpController < ApplicationController
  
  def preview
    render :action => "preview", :layout => false
  end
  
end

module MarkItUp
  module ViewHelpers
    include ActionView::Helpers::AssetTagHelper

    def mark_it_up(selector, options = nil, dependencies = true)
      settings = options || MarkItUp.settings
      html = ""
      if dependencies
        html << include_mark_it_up_javascripts
        html << include_mark_it_up_stylesheets
      end
      html << %{
<script type="text/javascript">
  jQuery(document).ready(function() {
    jQuery('#{selector}').markItUp(#{MarkItUp.format_settings(settings)})
  });
</script>
      }
      return_html_considering_rails_version(html)
    end

    def include_mark_it_up_javascripts
      js_file_name = Rails.env.production? ? "jquery.markitup.pack" : "jquery.markitup"
      return_html_considering_rails_version(javascript_include_tag("/#{MarkItUp.root}/#{js_file_name}.js"))
    end

    def include_mark_it_up_stylesheets
      css = stylesheet_link_tag("/#{MarkItUp.root}/skins/#{MarkItUp.skin}/style.css")
      inline_css = MarkItUp.markup_set.inject("") do |x,btn|
        icon = btn[:icon].blank? ? MarkItUp.default_icon : btn[:icon]
        icon.concat(".png") unless icon.match(MarkItUp::ICONS_EXTENSIONS_REGEXP)
        x.concat(btn[:className].blank? ? "" : ".markItUp .#{btn[:className]} a {background-image:url(#{image_path "/#{MarkItUp.root}/icons/#{icon}"})}\n")
      end
      css << return_html_considering_rails_version(%{
<style type="text/css" media="all">
#{inline_css}
</style>
      })
      css
    end

    private

      def return_html_considering_rails_version(html)
        (Rails::VERSION::MAJOR == 3) ? html.html_safe : html
      end

  end
end

ActionView::Base.send :include, MarkItUp::ViewHelpers
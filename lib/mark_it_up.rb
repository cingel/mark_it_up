module MarkItUp
  DEFAULT_ROOT = "mark_it_up"
  ICONS_EXTENSIONS_REGEXP = /\.(png|jpg|jpeg|gif)$/i
  
  @@settings = nil
  @@root = nil
  @@buttons = nil
  @@skin = "markitup"
  @@default_icon = "button"
  
  class << self
    
    def root
      @@root || DEFAULT_ROOT 
    end
    
    def root=(path)
      @@root = path
    end
    
    def settings
      @@settings || default_settings
    end
    
    def settings=(settings)
      @@settings = settings
    end
    
    def default_settings
      {
        :onShiftEnter => { :keepDefault => false, :replaceWith => "<br />\n" },
      	:onCtrlEnter => { :keepDefault => false, :openWith => "\n<p>", :closeWith => "</p>"},
      	:onTab => { :keepDefault => false, :replaceWith => '    ' },
      	:previewParserPath => "/mark_it_up/preview",
      	:markupSet => markup_set
      }.with_indifferent_access
    end
    
    def format_settings(settings)
      settings.to_json
    end
    
    def buttons
      @@buttons || default_buttons
    end
    
    def buttons=(buttons)
      @@buttons = buttons
    end
    
    def skin
      @@skin
    end
    
    def skin=(name)
      @@skin = name
    end
    
    def default_icon
      @@default_icon
    end
    
    def default_icon=(icon)
      @@default_icon = icon
    end
    
    def insert_button(*args)
      btns = self.buttons
      if args.size == 1 # Adds image to the end
        btns << args.first
        self.buttons = btns
      elsif args.size == 2 and args[1].is_a?(Hash) # Adds image at specific position
        index = args[0] - 1
        btns.insert(index, args[1])
        self.buttons = btns
      end
    end
    
    def replace_button(position, new_button)
      btns = self.buttons
      index = position - 1
      btns[index] = new_button
      self.buttons = btns
    end
    
    def delete_button(position_or_name)
      btns = self.buttons
      if position_or_name.is_a?(String)
        btns.delete_if { |btn| btn[:name] == position_or_name }
      else
        btns.delete_at(position_or_name - 1)
      end
      self.buttons = btns
    end
    
    def default_buttons
      [
        { :name => 'Heading 1', :icon => 'h1', :key => '1', :openWith => '<h1(!( class="[![Class]!]")!)>', :closeWith => '</h1>', :placeHolder => 'Your title here...' },
        { :name => 'Heading 2', :icon => 'h2', :key => '2', :openWith => '<h2(!( class="[![Class]!]")!)>', :closeWith => '</h2>', :placeHolder => 'Your title here...' },
        { :name => 'Heading 3', :icon => 'h3', :key => '3', :openWith => '<h3(!( class="[![Class]!]")!)>', :closeWith => '</h3>', :placeHolder => 'Your title here...' },
        { :name => 'Heading 4', :icon => 'h4', :key => '4', :openWith => '<h4(!( class="[![Class]!]")!)>', :closeWith => '</h4>', :placeHolder => 'Your title here...' },
        { :name => 'Heading 5', :icon => 'h5', :key => '5', :openWith => '<h5(!( class="[![Class]!]")!)>', :closeWith => '</h5>', :placeHolder => 'Your title here...' },
        { :name => 'Heading 6', :icon => 'h6', :key => '6', :openWith => '<h6(!( class="[![Class]!]")!)>', :closeWith => '</h6>', :placeHolder => 'Your title here...' },
        { :name => 'Paragraph', :icon => 'paragraph', :openWith => '<p(!( class="[![Class]!]")!)>', :closeWith => '</p>' },
        { :separator => '---------------' },
        { :name => 'Bold', :icon => 'bold', :key => 'B', :openWith => '(!(<strong>|!|<b>)!)', :closeWith => '(!(</strong>|!|</b>)!)' },
        { :name => 'Italic', :icon => 'italic', :key => 'I', :openWith => '(!(<em>|!|<i>)!)', :closeWith => '(!(<em>|!|<i>)!)' },
        { :name => 'Stroke through', :icon => 'stroke', :key => 'S', :openWith => '<del>', :closeWith => '</del>' },
        { :separator => '---------------' },
        { :name => 'Link', :icon => 'link', :openWith => '<a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)>', :closeWith => '</a>', :placeHolder => 'Your text to link...' },
        { :name => 'Picture', :icon => 'picture', :replaceWith => '<img src="[![Source:!:http://]!]" alt="[![Alternative text]!]" />' },
        { :separator => '---------------' },
        # Got to think of something for replaceWith to work with functions. Use :call => "myFunctionName" till then
        # { :name => 'Clean', :icon => 'clean', :replaceWith => "function(markitup) { return markitup.selection.replace(/<(.*?)>/g, '') }" },
        { :name => 'Preview', :icon => 'preview', :call => 'preview' }
    	]
    end
    
    def markup_set
      buttons.collect do |btn|
        if btn[:className].blank? and !btn[:separator]
          icon = btn[:icon].blank? ? self.default_icon : btn[:icon]
          class_name = icon.gsub(self::ICONS_EXTENSIONS_REGEXP, '')
          btn[:className] = "miu_#{class_name}"
        end
        btn
      end
    end
    
  end
  
end

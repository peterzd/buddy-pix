class ApplicationDecorator < Draper::Decorator

  class << self
    def flash_message
      return if h.flash.empty?
      type = h.flash.keys.first
      h.content_tag(:div, h.content_tag(:i, "", class: "fa fa-times") + h.flash[type.to_sym], class: "msg #{type}")
    end

    def flash_messages
      return if h.flash.empty?
      output = ""
      h.flash.keys.each do |type|
        output << h.content_tag(:div, h.content_tag(:i, "", class: "fa fa-times") + h.flash[type.to_sym], class: "msg #{type}")
      end
      output
    end

  end # end of cless methods
end

class ApplicationDecorator < Draper::Decorator

  class << self
    def flash_message
      return if h.flash.empty?
      type = h.flash.keys.first
      h.content_tag(:div, h.content_tag(:i, "", class: "fa fa-times") + h.flash[type.to_sym], class: "msg #{type}")
    end

  end # end of cless methods
end

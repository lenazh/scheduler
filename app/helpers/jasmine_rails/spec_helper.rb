module JasmineRails
  module SpecHelper
    include ApplicationHelper
    include Rails.application.routes.url_helpers

# This hack makes gon available to 
# Jasmine template
# Based on gazay/gon/lib/gon/base.rb
    def jasmine_gon_render
      script = ''
      script << "<script type=\"text/javascript\">\n"
      script << "//<![CDATA[\n"
      script << 'window.gon={};'
      script << gon_variables.map { |key, val| render_variable(key, val) }.join 
      script << "\n//]]>\n"
      script << '</script>'
    end

    def render_variable(key, value)
      value.slice! "/specs"
      "gon.#{key.to_s}=\"#{value}\";"
    end


  end
end


module JasmineRails
  module SpecHelper
    include ApplicationHelper
    def custom_method
      "Class name is #{self.to_s}"
      #set_gon_variables()
    end
  end
end


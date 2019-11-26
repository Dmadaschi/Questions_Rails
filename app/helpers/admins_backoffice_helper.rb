# frozen_string_literal: true

module AdminsBackofficeHelper
  def translate_attribute(object = nil, attribute = nil)
    if object && attribute
      object.model.human_attribute_name(attribute)
    else
      'please, send the parameters'
    end
  end
end

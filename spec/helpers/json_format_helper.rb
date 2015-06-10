module JsonFormatHelper
  def attributes_match(result)
    if result.kind_of?(Array)
      match_array(result)
    else
      match_single(result)
    end
  end

private
  def match_array(result)
    mock_attributes.each_with_index do |mock, id|
      mock.each do |key, val|
        expect(result[id][key.to_s]).to eq val
      end
    end
  end

  def match_single(result)
    mock_attributes.each do |key, val|
      expect(result[key.to_s]).to eq val
    end
  end
end
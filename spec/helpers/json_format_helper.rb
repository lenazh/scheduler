module JsonFormatHelper
  def attributes_match(result)
    if result.kind_of?(Array)
      match_array(result)
    else
      match_single(result)
    end
  end

private
  def is_float(var); true if Float(var) rescue false; end
  def is_integer(var); true if Integer(var) rescue false; end

  def match_as_floats(actual, expected)
    expected_float = expected.to_f
    actual_float = actual.to_f
    expect(expected_float).to be_within(1e-3).of(actual_float)
  end

  def match_as_integers(actual, expected)
    expected_int = expected.to_i
    actual_int = actual.to_i
    expect(expected_int).to eq actual_int
  end

  def expect_to_match(actual, expected)
    if is_integer(expected)
      match_as_integers(actual, expected)
    elsif is_float(expected)
      match_as_floats(actual, expected)
    else
      expect(expected).to eq actual  
    end

  end

  def match_array(result)
    mock_attributes.each_with_index do |mock, id|
      mock.each do |key, val|
        expect_to_match result[id][key.to_s], val
      end
    end
  end

  def match_single(result)
    mock_attributes.each do |key, val|
      expect_to_match result[key.to_s], val
    end
  end
end
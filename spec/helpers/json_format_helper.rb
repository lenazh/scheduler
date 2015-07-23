# Tests that the JSON responses (show and index views)
# contain all the fields they are supposed to, and the
# data in these fields matches the expected values
module JsonFormatHelper
  def attributes_match(result, expected)
    if result.kind_of?(Array)
      match_array(result, expected)
    else
      match_single(result, expected)
    end
  end

  private

  def float?(var)
    true if Float(var) rescue false
  end

  def integer?(var)
    true if Integer(var) rescue false
  end

  def match_as_floats(actual, expected, key)
    expected_float = expected.to_f
    actual_float = actual.to_f
    expect(expected_float).to be_within(1e-3).of(actual_float),
                              message(actual, expected, key)
  end

  def match_as_integers(actual, expected, key)
    expected_int = expected.to_i
    actual_int = actual.to_i
    expect(expected_int).to eq(actual_int), message(actual, expected, key)
  end

  def expect_to_match(actual, expected, key)
    if integer?(expected)
      match_as_integers(actual, expected, key)
    elsif float?(expected)
      match_as_floats(actual, expected, key)
    else
      expect(expected).to eq(actual), message(actual, expected, key)
    end
  end

  def match_array(results, expected)
    results.each_with_index do |result, id|
      match_single(result, expected[id])
    end
  end

  def match_single(result, expected)
    result.stringify_keys!
    expected.stringify_keys!
    expected_fields.each do |key|
      if key == 'id'
        expect(result['id']).not_to be(nil)
        expect(result['id']).not_to be(0)
      else
        expect_to_match result[key], expected[key], key
      end
    end
  end

  def message(actual, expected, key)
    "#{key} does not match, expected: #{expected}, got: #{actual}"
  end


end

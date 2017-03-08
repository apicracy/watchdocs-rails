class Hash
  def filter_data
    filtered = map do |k, v|
      if v.is_a?(Enumerable)
        [k, v.filter_data]
      else
        [k, v.json_data_type]
      end
    end
    Hash[filtered]
  end

  def upcased_keys
    map { |k, _v| k.upcase }
  end
end

class Object
  def json_data_type
    if is_a?(Numeric)
      'number'
    elsif is_a?(NilClass)
      'null'
    elsif is_a?(String)
      'string'
    elsif is_a?(TrueClass) || is_a?(FalseClass)
      'boolean'
    else
      '*****'
    end
  end
end

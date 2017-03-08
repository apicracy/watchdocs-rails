module Enumerable
  def filter_data
    map do |v|
      if v.is_a?(Enumerable)
        v.filter_data
      else
        v.json_data_type
      end
    end
  end
end

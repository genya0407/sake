module Sake::Series::Init
  def self.initialize_values(source, dtype)
    if source.is_a? Array
      array = source
    elsif source.is_a? Hash
      array = source.values
    else
      raise ArgumentError
    end
    
    if dtype.nil?
      Numo::NArray.from_array(array)
    else
      Numo.const_get(dtype).new(array.length).store array
    end
  end

  def self.initialize_index(source, index)
    return Sake::Index.new(index) unless index.nil?
    
    if source.is_a? Array
      Sake::Index.new((0...(source.length)).to_a)
    elsif source.is_a? Hash
      Sake::Index.new(source.keys)
    else
      raise ArgumentError
    end
  end
end

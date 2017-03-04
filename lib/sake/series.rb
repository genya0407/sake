class Sake::Series
  attr_accessor :index, :values
  
  def initialize(source, index: nil, dtype: nil, direct: false)
    if direct
      self.values = source
      self.index = index
    else
      self.values = Initializer.initialize_values(source, dtype)
      self.index = Initializer.initialize_index(source, index)
    end
    
    raise ArgumentError unless self.values.length == self.index.length
  end
  
  def [](*sake_index)
    values_view = values[index.narray_index(sake_index)]
    index_view = index.view(sake_index)
    self.class.new(values_view, index: index_view, direct: true)
  end
  
  def []=(*sake_index, value)
    values[index.narray_index(sake_index)] = value
  end
end

class Sake::Series::Initializer
  class << self
    def initialize_values(source, dtype)
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

    def initialize_index(source, index)
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
end

require './series/init'
class Sake::Series
  attr_accessor :index, :values
  
  def initialize(source, index: nil, dtype: nil, direct: false)
    if direct
      self.values = source
      self.index = index
    else
      self.values = Init.initialize_values(source, dtype)
      self.index = Init.initialize_index(source, index)
    end
    
    raise ArgumentError unless self.values.length == self.index.length
  end

  def [](*sake_index)
    if sake_index.length == 1
      values[index.narray_index(sake_index.first)]
    else
      values_view = values[index.narray_index(sake_index)]
      index_view = index.view(sake_index)
      self.class.new(values_view, index: index_view, direct: true)
    end
  end
  
  def []=(*sake_index, value)
    values[index.narray_index(sake_index)] = value
  end

  end
end

require 'sake/series/init'
require 'sake/series/to_html'

class Sake::Series
  include ToHTML

  attr_accessor :index, :values

  [:>, :<, :>=, :<=, :==].each do |operator|
    define_method(operator) do |other|
      compare(operator, other)
    end
  end
  
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
    if sake_index.length == 1
      narray_index = index.narray_index(sake_index.first)
    else
      narray_index = index.narray_index(sake_index)
    end

    values[narray_index] = value
  end

  def each_with_index(&block)
    values.zip(index).each(&block)
  end

  private
  def compare(operator, other)
    sake_index = each_with_index.select { |value, _| value.send(operator, other) }
                                .map { |_, sake_index| sake_index }
    Sake::Index::Condition.new(sake_index)
  end
end

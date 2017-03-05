require 'sake/index/condition'

class Sake::Index
  def initialize(array)
    if array.is_a? Array
      @array = Numo::NArray.from_array array
    elsif array.is_a? Numo::NArray
      @array = array
    else
      raise ArgumentError
    end
  end
  
  def narray_index(arg)
    if arg.is_a? Array
      positions_from_index(arg)
    elsif arg.is_a? Condition
      positions_from_condition(arg)
    else
      positions_from_element(arg)
    end
  end

  def view(sake_index)
    self.class.new(@array[narray_index(sake_index)])
  end
  
  def length
    @array.length
  end

  def each(&block)
    @array.each(&block)
  end

  private
  def positions_from_index(array)
    if array.all? { |elem| @array.include? elem }
      array.map { |elem| @array.find_index(elem) }
    else
      raise ArgumentError
    end
  end

  def positions_from_condition(condition)
    positions_from_index(condition.array)
  end

  def positions_from_element(elem)
    if @array.include? elem
      @array.find_index(elem)
    else
      raise ArgumentError
    end
  end
end

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
  
  def narray_index(sake_index)
    positions(sake_index)
  end
  
  def view(sake_index)
    self.class.new(@array[positions(sake_index)])
  end
  
  def length
    @array.length
  end

  private
  def positions(sake_index)
    if sake_index.is_a? Array
      unless sake_index.all? { |elem| @array.include? elem }
        raise ArgumentError
      end
    
      sake_index.map { |elem| @array.find_index(elem) }
    else
      unless @array.include? sake_index
        raise ArgumentError
      end

      @array.find_index(sake_index)
    end
  end
end

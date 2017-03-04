class Numo::NArray
  include Enumerable

  class << self
    def from_array(array)
      dtype = examine_dtype(array)
      Numo.const_get(dtype).new(array.length).store(array)
    end

    private
    def examine_dtype(array)
      if array_is_a?(array, Fixnum)
        :Int64
      elsif array_is_a?(array, Float)
        :DFloat
      elsif array_is_a?(array, Complex)
        :DComplex
      else
        :RObject
      end
    end

    def array_is_a?(array, type)
      array.all? { |elem| elem.is_a? type }
    end
  end
end

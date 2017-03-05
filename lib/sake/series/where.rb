module Sake::Series::Where
  [:>, :<, :>=, :<=, :==].each do |operator|
    define_method(operator) do |other|
      compare(operator, other)
    end
  end

  private
  def compare(operator, other)
    each_with_index.select { |value, _| value.send(operator, other) }
                   .map { |_, index| index }
  end
end

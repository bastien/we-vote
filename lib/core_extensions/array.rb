class Array
  def average
    return nil if size < 1
    sum / size.to_f
  end
end
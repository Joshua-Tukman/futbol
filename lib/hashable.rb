module Hashable

  def key_with_max_value(hash)
    hash.key(hash.values.max)
  end

  def key_with_min_value(hash)
    hash.key(hash.values.min)
  end
end

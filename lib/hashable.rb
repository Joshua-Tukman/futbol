module Hashable

  def key_with_max_value(hash)
    hash.key(hash.values.max)
  end

end

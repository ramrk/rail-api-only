class Item < ApplicationRecord
  def to_s
    "#{name}, #{sell_in}, #{quality}"
  end
end

FactoryBot.define do
  factory :item do
    name { "Item Name" }
    sell_in { 10 }
    quality { 20 }
  end
end
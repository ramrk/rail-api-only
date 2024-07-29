class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when "Aged Brie"
        update_aged_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert"
        update_backstage_passes(item)
      when "Sulfuras, Hand of Ragnaros"
        update_sulfuras(item)
      else
        update_regular_item(item)
      end
  
      item.sell_in -= 1 unless item.name == "Sulfuras, Hand of Ragnaros"
      handle_expired_item(item)
    end
  end

  def update_aged_brie(item)
    item.quality += 1 if item.quality < 50
  end

  def update_backstage_passes(item)
    if item.sell_in < 6
      item.quality += 3
    elsif item.sell_in < 11
      item.quality += 2
    else
      item.quality += 1
    end
    item.quality = 50 if item.quality > 50
  end

  def update_sulfuras(item)
    # Sulfuras does not change in quality or sell_in
  end

  def update_regular_item(item)
    item.quality -= 1 if item.quality > 0
  end

  def handle_expired_item(item)
    return unless item.sell_in < 0

    case item.name
    when "Aged Brie"
      item.quality += 1 if item.quality < 50
    when "Backstage passes to a TAFKAL80ETC concert"
      item.quality = 0
    when "Sulfuras, Hand of Ragnaros"
      # No change for Sulfuras
    else
      item.quality -= 1 if item.quality > 0
    end
  end

end

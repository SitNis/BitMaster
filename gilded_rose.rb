# rubocop:disable all

class GildedRose
  AGED_BRIE = 'Aged Brie'
  SULFURAS = 'Sulfuras, Hand of Ragnaros'
  BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'
  CONJURED_ITEM_REGEXP = /^Conjured/

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      before_day_gone_updates(item)

      day_passed(item)

      if item.sell_in < 0
        after_day_gone_updates(item)
      end
    end
  end

  private

  def before_day_gone_updates(item)
    case item.name
    when SULFURAS
      nil
    when AGED_BRIE
      increase_quality(item)
    when BACKSTAGE_PASSES
      update_backstage_pass(item)
    when CONJURED_ITEM_REGEXP
      update_conjured(item)
    else
      update_item(item)
    end
  end

  def after_day_gone_updates(item)
    case item.name
    when SULFURAS
      nil
    when AGED_BRIE
      increase_quality(item)
    when BACKSTAGE_PASSES
      concert_passed(item)
    when CONJURED_ITEM_REGEXP
      update_conjured(item)
    else
      update_item(item)
    end
  end

  def decrease_quality(item)
    item.quality -= 1 if item.quality > 0
  end

  def increase_quality(item)
    item.quality += 1 if item.quality < 50
  end

  def update_conjured(item)
    decrease_quality(item)
    decrease_quality(item)
  end

  def update_item(item)
    decrease_quality(item)
  end

  def update_backstage_pass(item)
    increase_quality(item)

    if item.sell_in < 11
      increase_quality(item)
    end

    if item.sell_in < 6
      increase_quality(item)
    end
  end

  def day_passed(item)
    return if item.name == SULFURAS

    item.sell_in -= 1
  end

  def concert_passed(item)
    item.quality = 0
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

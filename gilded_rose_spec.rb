# rubocop:disable all

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality

      expect(items[0].name).to eq 'foo'
    end

    it "doesn't update quality > 50" do
      items = [Item.new('Aged Brie', -1, 49)]
      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 50
      expect(items[0].sell_in).to eq -2
    end

    it "doesn't update quality < 0" do
      items = [Item.new('item', -1, 0)]
      GildedRose.new(items).update_quality

      expect(items[0].quality).to eq 0
      expect(items[0].sell_in).to eq -2
    end

    describe 'Sulfuras, Hand of Ragnaros' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]

      GildedRose.new(items).update_quality

      it 'does not change quality' do
        expect(items[0].quality).to eq 80
      end

      it 'does not change sell_in' do
        expect(items[0].sell_in).to eq 0
      end
    end

    describe 'Aged Brie' do
      items = [Item.new('Aged Brie', 3, 5),
               Item.new('Aged Brie', 0, 30)]

      gilded_rose = GildedRose.new(items)

      2.times do
        gilded_rose.update_quality
      end

      it 'incremet quality and decrement sell_in' do
        expect(items[0].quality).to eq 7
        expect(items[0].sell_in).to eq 1
      end

      it 'increment quality twice then sell_in expired' do
        expect(items[1].quality).to eq 34
        expect(items[1].sell_in).to eq -2
      end
    end

    describe 'Backstage passes to a TAFKAL80ETC concert' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 50),
               Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 30),
               Item.new('Backstage passes to a TAFKAL80ETC concert', 7, 30)]

      gilded_rose = GildedRose.new(items)

      it 'sets quality to 0 then concert passed' do
        gilded_rose.update_quality

        expect(items[0].quality).to eq 0
        expect(items[0].sell_in).to eq -1
      end

      it 'increment by 2 then it less then 11 days till concert' do
        expect(items[1].quality).to eq 31
        expect(items[1].sell_in).to eq 10

        gilded_rose.update_quality

        expect(items[1].quality).to eq 33
        expect(items[1].sell_in).to eq 9
      end

      it 'increment by 3 then it less then 6 days till concert' do
        expect(items[2].quality).to eq 34
        expect(items[2].sell_in).to eq 5

        gilded_rose.update_quality

        expect(items[2].quality).to eq 37
        expect(items[2].sell_in).to eq 4
      end
    end

    describe 'Conjured items' do
      items = [Item.new('Conjured cake', 4, 50),
               Item.new('Conjured cola', -1, 30)]

      gilded_rose = GildedRose.new(items)

      it 'decrement quality twice then sell_in > 0' do
        gilded_rose.update_quality

        expect(items[0].quality).to eq 48
        expect(items[0].sell_in).to eq 3
      end

      it 'decrement quality four times then sell_in expired' do
        gilded_rose.update_quality

        expect(items[1].quality).to eq 22
        expect(items[1].sell_in).to eq -3
      end
    end

    describe 'default item' do
      items = [Item.new('Mana potion', 4, 50),
               Item.new('Health potion', -1, 30)]

      gilded_rose = GildedRose.new(items)

      it 'decrement quality then sell_in > 0' do
        gilded_rose.update_quality

        expect(items[0].quality).to eq 49
        expect(items[0].sell_in).to eq 3
      end

      it 'decrement quality twice then sell_in expired' do
        expect(items[1].quality).to eq 28
        expect(items[1].sell_in).to eq -2
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Item, type: :model do

  before(:all) do
    load "#{Rails.root}/db/test_seeds/items/items.rb"
  end


  it "returns a valid item" do
    @items = Item.all
    expect(@items.count).to eq(2)
  end

  it "returns error message if item number is not unique" do
    item1 = Item.new
    item1.item_number = '1234'
    item1.item_product = 'ABCD'
    item1.finished_size = '500 X 456'
    item1.setup_price = 10.2
    item1.unit_price = 12.3
    item1.archived = 0
    item1.created_by = "rspec"
    item1.updated_by = "rspec"
    expect(item1.save).to be true
    item2 = Item.new
    item2.item_number = '1234'
    item2.item_product = 'ABCD'
    item2.finished_size = '500 X 456'
    item2.setup_price = 10.2
    item2.unit_price = 12.3
    item2.archived = 0
    item2.created_by = "rspec"
    item2.updated_by = "rspec"
    expect {item2.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    # expect(item2.errors[:item_number]).to include(["duplicate key value violates unique constraint"])
  end

  it "returns error message when item_number is too long" do
    item1 = Item.new
    item1.item_number = '01234567891012345678910'
    item1.item_product = 'ABCD'
    item1.finished_size = '500 X 456'
    item1.setup_price = 10.2
    item1.unit_price = 12.3
    item1.archived = 0
    expect(item1.valid?).to eq(false)
    expect(item1.errors[:item_number]).to eq(["is too long (maximum is 20 digits)"])
  end

end

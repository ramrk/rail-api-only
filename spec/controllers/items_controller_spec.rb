require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let!(:items) { create_list(:item, 10) }
  let(:item_id) { items.first.id }

  describe "GET #index" do
    before { get :index }

    it 'returns items' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    before { get :show, params: { id: item_id } }

    context 'when the record exists' do
      it 'returns the item' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(item_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:item_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { name: 'Aged Brie', sell_in: 10, quality: 20 } }

    context 'when the request is valid' do
      before { post :create, params: valid_attributes }

      it 'creates an item' do
        expect(json['name']).to eq('Aged Brie')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post :create, params: { name: 'Aged Brie' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Sell in can't be blank, Quality can't be blank/)
      end
    end
  end

  describe "PUT #update" do
    let(:valid_attributes) { { name: 'Elixir of the Mongoose' } }

    context 'when the record exists' do
      before { put :update, params: { id: item_id, item: valid_attributes } }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "DELETE #destroy" do
    before { delete :destroy, params: { id: item_id } }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
     
  describe "PUT #update_quality" do
    before { put :update_quality }
    context "with Aged Brie" do
      let(:items) { [Item.new("Aged Brie", 10, 25)] }

      it "increases quality by 1 when sell_in is above 0" do
        gilded_rose.update_quality
        expect(items[0].quality).to eq 26
        expect(items[0].sell_in).to eq 9
      end

      it "increases quality by 2 when sell_in is 0 or less" do
        items[0].sell_in = 0
        gilded_rose.update_quality
        expect(items[0].quality).to eq 27
        expect(items[0].sell_in).to eq -1
      end
    end

    context "with Backstage passes to a TAFKAL80ETC concert" do
      let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)] }

      it "increases quality by 1 when sell_in is more than 10" do
        gilded_rose.update_quality
        expect(items[0].quality).to eq 21
        expect(items[0].sell_in).to eq 14
      end

      it "increases quality by 2 when sell_in is 10 or less but more than 5" do
        items[0].sell_in = 10
        gilded_rose.update_quality
        expect(items[0].quality).to eq 22
        expect(items[0].sell_in).to eq 9
      end

      it "increases quality by 3 when sell_in is 5 or less but more than 0" do
        items[0].sell_in = 5
        gilded_rose.update_quality
        expect(items[0].quality).to eq 23
        expect(items[0].sell_in).to eq 4
      end

      it "sets quality to 0 when sell_in is 0 or less" do
        items[0].sell_in = 0
        gilded_rose.update_quality
        expect(items[0].quality).to eq 0
        expect(items[0].sell_in).to eq -1
      end
    end

    context "with Sulfuras, Hand of Ragnaros" do
      let(:items) { [Item.new("Sulfuras, Hand of Ragnaros", 10, 80)] }

      it "does not change quality or sell_in" do
        gilded_rose.update_quality
        expect(items[0].quality).to eq 80
        expect(items[0].sell_in).to eq 10
      end
    end

    context "with regular items" do
      let(:items) { [Item.new("Regular Item", 10, 20)] }

      it "decreases quality by 1 when sell_in is above 0" do
        gilded_rose.update_quality
        expect(items[0].quality).to eq 19
        expect(items[0].sell_in).to eq 9
      end

      it "decreases quality by 2 when sell_in is 0 or less" do
        items[0].sell_in = 0
        gilded_rose.update_quality
        expect(items[0].quality).to eq 18
        expect(items[0].sell_in).to eq -1
      end
    end
  end
end

def json
  JSON.parse(response.body)
end

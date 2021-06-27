require 'inverted_index/base_index'

describe InvertedIndex::BaseIndex do
  describe 'add_new_pair_to_search_hash' do
    let(:element_id) { :id1 }
    let(:key) { :key1 }
    let(:value) { 'Value1' }

    subject { described_class.add_new_pair_to_search_hash(search_hash, key, value, element_id) }

    context 'empty search_hash' do
      let(:search_hash) { {} }

      it 'should add a new key value pair' do
        subject

        expect(search_hash[key][value.downcase.to_sym]).to eq [element_id.to_sym]
      end
    end

    context "key exist search_hash but inverted index 'value' not exist" do
      let(:search_hash) { { key2 => { value2 => [element_id2] } } }
      let(:key2) { :key2 }
      let(:value2) { :value2 }
      let(:element_id2) { :id2 }

      before do
        subject
      end

      it 'should add a new key value pair' do
        expect(search_hash[key][value.downcase.to_sym]).to eq [element_id.to_sym]
      end

      it 'should keep existing key value pair' do
        expect(search_hash[key2][value2]).to eq [element_id2]
      end
    end

    context "key and inverted index 'value' exist search_hash" do
      let(:search_hash) { { key => { value.downcase.to_sym => [element_id2] } } }
      let(:element_id2) { :id2 }

      before do
        subject
      end

      it "should add the id to the existing inverted index 'value'" do
        expect(search_hash[key][value.downcase.to_sym]).to eq [element_id2, element_id.to_sym]
      end
    end
  end
end

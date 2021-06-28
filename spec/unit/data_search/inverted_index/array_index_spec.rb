require 'inverted_index/array_index'

describe InvertedIndex::ArrayIndex do
  describe 'add_new_pair_to_search_hash' do
    let(:element_id) { :id1 }
    let(:key) { :key }
    let(:array_value) { [value1, value2] }
    let(:value1) { :value1 }
    let(:value2) { :value2 }

    subject do
      described_class.add_new_pair_to_search_hash(search_hash, key, array_value, element_id)
    end

    before do
      subject
    end

    context 'no value exist in search_hash' do
      let(:search_hash) { {} }

      it 'should add new inverted index of each value of the array with element id' do
        expect(search_hash[key][value1]).to eq [element_id]
        expect(search_hash[key][value2]).to eq [element_id]
      end
    end

    context "exist inverted index 'value'" do
      let(:search_hash) { { key: { value1: [element_id2] } } }
      let(:element_id2) { :id2 }

      it 'should add new id as the value of the inverted index' do
        expect(search_hash[key][value1]).to eq [element_id2, element_id]
      end
    end
  end
end

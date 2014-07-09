require 'spec_helper'

module TransForms
  describe NestedForms do

    describe '#each_nested_hash_for' do
      it 'iterates through nested hash values and turns all hash keys into string values' do
        attr = { 0 => { id: 1 }, 1 => { id: 2 } }

        iterations = 0
        NestedFormsModel.new.each_nested_hash_for attr do |nested_hash|
          expect(nested_hash).to eq attr[iterations].stringify_keys
          iterations += 1
        end
        expect(iterations).to eq 2
      end

      it 'skips iterating over values that are not hashes' do
        attr = { 0 => { name: 'John' }, 1 => 'Not a Hash' }

        iterations = 0
        NestedFormsModel.new.each_nested_hash_for attr do |nested_hash|
          expect(nested_hash).to eq attr[iterations].stringify_keys
          iterations += 1
        end
        expect(iterations).to eq 1
      end

      it 'creates two nested PhoneNumber records for a User record' do
        attr = { name: 'John', phone_numbers_attributes: {
            '0' => { number: '+1-555-CALL-JOHN' },
            '1' => { number: '+1-555-FOO-BAR' }
        } }
        count = PhoneNumber.count
        expect(UserAndPoneNumbersCreator.new(attr).save).to be true
        expect(PhoneNumber.count).to eq(count+2)
      end
    end

    describe '#any_nested_hash_for?' do
      it 'returns false unless there is at least one nested Hash value with at least one non-blank value' do
        form = NestedFormsModel.new

        expect(form.any_nested_hash_for?({  })).to be false
        expect(form.any_nested_hash_for?({ '0' => 'Not a Hash' })).to be false
        expect(form.any_nested_hash_for?({ '0' => {  } })).to be false
        expect(form.any_nested_hash_for?({ '0' => { name: '' } })).to be false
        expect(form.any_nested_hash_for?({ '0' => { name: 'Not a blank value' } })).to be true
      end
    end
  end

end

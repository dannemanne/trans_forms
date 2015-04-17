require 'spec_helper'

module TransForms
  describe FormBase do

    describe '#initialize' do
      it 'assigns attributes defined by +attribute+' do
        attr = { name: 'John Doe', age: 30, foo: 'bar' }
        form = UserCreator1.new(attr)

        expect(form.name).to    eq(attr[:name])
        expect(form.age).to     eq(attr[:age])
        expect { form.foo }.to  raise_error
      end
    end

    describe 'validations' do
      it 'is considered valid when validations pass' do
        attr = { name: 'John Doe', age: 30 }
        form = UserCreator1.new(attr)
        expect(form).to     be_valid

        form.name = ''
        expect(form).not_to be_valid
      end
    end

    describe '#save' do
      context 'when no errors occur inside +transaction+ block' do
        let(:form) { NoErrorInTransactionForm.new }
        it { expect( form.save ).to be true }
      end

      context 'when errors do occur inside the +transaction+ block' do
        let(:form) { ErrorInTransactionForm.new }
        it { expect( form.save ).to be false }
      end
    end

    describe '#save!' do
      context 'when no errors occur inside +transaction+ block' do
        let(:form) { NoErrorInTransactionForm.new }
        it { expect( form.save! ).to be true }
      end

      context 'when errors do occur inside the +transaction+ block' do
        let(:form) { ErrorInTransactionForm.new }
        it { expect { form.save! }.to raise_error(ActiveRecord::RecordNotSaved) }
      end
    end

    describe 'transaction' do
      it 'saves multiple records to db when nothing raises errors' do
        attr = { name1: 'John', name2: 'Peter' }
        count = User.count

        expect(MultipleRecordsCreator.new(attr).save).to be true
        expect(User.count).to eq(count+2)
      end

      it 'rollbacks both saves even if the first is successful and the last one raises an error' do
        # First User is saved successfully, but last one will raise an
        # error because of User class uniqueness validation on +name+
        attr = { name1: 'John', name2: 'John' }
        count = User.count

        expect(MultipleRecordsCreator.new(attr).save).to be false
        expect(User.count).to eq(count)
      end

      it 'does not cause rollback when save is not raising error (no !), even though it was not saved' do
        attr = { name1: 'John', name2: 'John' }
        count = User.count

        expect(MultipleRecordsCreatorNoBang.new(attr).save).to be true
        expect(User.count).to eq(count+1) # Only one record saved
      end
    end

  end

end

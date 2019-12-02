require 'spec_helper'

module TransForms
  describe FormBase do

    describe '#initialize' do
      subject { UserCreator1.new(attr) }

      context 'when assigning attributes defined by +attribute+' do
        let(:attr) { { name: 'John Doe', age: 30 } }

        it { is_expected.to be_a UserCreator1 }

        it 'assigns attributes and responds to method calls' do
          expect(subject.name).to eq attr[:name]
          expect(subject.age).to eq attr[:age]
        end
      end

      context 'when assigning attributes defined by +attr_accessor+' do
        let(:attr) { { extra_attribute: 'value' } }

        it { is_expected.to be_a UserCreator1 }

        it 'assigns and responds to method calls' do
          expect(subject.extra_attribute).to eq attr[:extra_attribute]
        end
      end

      context 'when assigning attributes that are not defined in any way' do
        let(:attr) { { foo: 'bar' } }

        it { is_expected.to be_a UserCreator1 }

        it 'does not assign or respond to method call' do
          expect { subject.foo }.to  raise_error(NoMethodError)
        end
      end
    end

    describe 'validations' do
      subject { form.valid? }

      context 'when validations pass' do
        let(:form) { UserCreator1.new(attr) }
        let(:attr) { { name: 'John Doe', age: 30 } }

        it { is_expected.to be true }
      end

      context 'when validations fail' do
        let(:form) { UserCreator1.new(attr) }
        let(:attr) { { name: '', age: 30 } }

        it { is_expected.to be false }
      end
    end

    describe '#save' do
      subject { form.save }

      context 'when no errors occur inside +transaction+ block' do
        let(:form) { NoErrorInTransactionForm.new }

        it { is_expected.to be true }
      end

      context 'when errors do occur inside the +transaction+ block' do
        let(:form) { ErrorInTransactionForm.new }

        it { is_expected.to be false }
      end
    end

    describe '#save!' do
      subject { form.save! }

      context 'when no errors occur inside +transaction+ block' do
        let(:form) { NoErrorInTransactionForm.new }

        it { is_expected.to be true }
      end

      context 'when active record errors do occur inside the +transaction+ block' do
        let(:form) { ErrorInTransactionForm.new }

        it { expect{ subject }.to raise_error(ActiveRecord::ActiveRecordError) }
      end

      context 'when RecordNotFound error occur inside the +transaction+ block' do
        let(:form) { RecordNotFoundInTransactionForm.new }

        it { expect{ subject }.to raise_error(ActiveRecord::RecordNotFound) }
      end

      context 'when RecordNotSaved error occur inside the +transaction+ block' do
        let(:form) { RecordNotSavedInTransactionForm.new }

        it { expect{ subject }.to raise_error(ActiveRecord::RecordNotSaved) }
      end

      context 'when RecordInvalid error occur inside the +transaction+ block' do
        let(:form) { RecordInvalidInTransactionForm.new }

        it { expect{ subject }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end

    describe 'transaction' do
      subject { form.save }

      context 'when trying to create multiple records inside a transaction without errors' do
        let(:form) { MultipleRecordsCreator.new(attr) }
        let(:attr) { { name1: 'John', name2: 'Peter' } }

        it { expect(subject).to be true }

        it 'saves multiple records' do
          expect{ subject }.to change{ User.count }.by 2
        end
      end

      context 'when trying to create multiple records but second record fails to create because of validation error' do
        let(:form) { MultipleRecordsCreator.new(attr) }
        let(:attr) { { name1: 'John', name2: 'John' } }

        it { expect(subject).to be false }

        it 'rollbacks both saves' do
          expect{ subject }.not_to change{ User.count }
        end
      end

      context 'when trying to create multiple records and second record fails to create because of validations, but failed save did not raise error' do
        let(:form) { MultipleRecordsCreatorNoBang.new(attr) }
        let(:attr) { { name1: 'John', name2: 'John' } }

        it { expect(subject).to be true }

        it 'does not cause rollback and successfully saved the first record' do
          expect{ subject }.to change{ User.count }.by 1
        end
      end

      context 'when +set_main_model+ is used and main instance is raising an error inside the transaction' do
        let(:user) { User.new }
        let(:form) { UserProxyModel.new({ model: user, name: '' }) }

        it { expect(subject).to be false }

        it 'does not create a new User' do
          expect{ subject }.not_to change{ User.count }
        end

        it 'does not create a new User' do
          form.save

          expect(form.errors).to eq user.errors
        end
      end
    end

  end

end

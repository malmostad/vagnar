require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { create(:company) }

  describe 'create' do
    it 'should be adding one' do
      expect { create(:company) }.to change(Company, :count).by(+1)
    end
  end

  describe 'destroy' do
    it 'should not be allowed' do
      create(:company)
      expect { Company.last.destroy }.to raise_error(RuntimeError)
    end
  end
end

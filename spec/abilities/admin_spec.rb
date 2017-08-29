require 'rails_helper'

RSpec.describe User, type: :ability do
  describe "with admin role" do
    # subject(:ability) { Ability.new(user) }
    #
    # let(:user) { build(:user, role: 'admin') }
    # let(:booking) { create(:booking) }
    #
    # it { should be_able_to(:manage, User.new) }
    # it { should be_able_to(:destroy, Booking.new) }
    #
    # it { should_not be_able_to(:destroy, User.new) }
  end
end

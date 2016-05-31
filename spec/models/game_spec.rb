require 'rails_helper'

describe Game, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:ps_id) }
  it { is_expected.to validate_uniqueness_of(:ps_id) }

  it { is_expected.to have_many(:screenshoots).dependent(:destroy) }
  it { is_expected.to have_many(:prices).dependent(:destroy) }

  it 'generates permalink after create' do
    game = create(:game, name: 'Battlefield 4')
    expect(game.permalink).to eq('battlefield-4')
  end
end

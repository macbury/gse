require 'rails_helper'

describe PlayStation::Game do
  it 'extract information about example game' do
    game = described_class.new(JSON.parse(open(Rails.root.join('spec/fixtures/games/ps_dungeon2.json')).read))
    expect(game.name).to eq('Dungeons 2')
    expect(game.price.to_i).to eq(169)
  end
end

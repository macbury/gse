require 'rails_helper'

describe PlayStation::Store do
  let(:consumer) { @consumer ||= described_class.new }

  it 'fetch first 30 games', vcr: 'first-30-games' do
    expect(consumer.next).to be(true)
    games = consumer.games
    expect(games).not_to be_empty
    expect(games.size).to eq(30)
    expect(consumer.page).to eq(1)
  end

  it 'does return game class for first', vcr: '30-games' do
    consumer.next
    game = consumer.first
    expect(game).not_to be_nil
    expect(game.class).to eq(PlayStation::Game)
  end
end

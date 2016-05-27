require 'rails_helper'

describe PlayStation::StoreConsumer do
  let(:consumer) { @consumer ||= PlayStation::StoreConsumer.new }

  it 'should fetch first 30 games', vcr: 'first-30-games' do
    expect(consumer.next).to be(true)
    games = consumer.games
    expect(games).not_to be_empty
    expect(games.size).to eq(30)
    expect(consumer.page).to eq(1)
  end

  it 'should fetch next 30 games', vcr: '60-games' do
    2.times { consumer.next }
    expect(consumer.page).to eq(2)
  end
end

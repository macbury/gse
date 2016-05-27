require 'rails_helper'

describe PlayStation::StoreConsumer, vcr: 'games' do
  let(:consumer) { @consumer ||= PlayStation::StoreConsumer.new }

  it 'should fetch first 30 games' do
    games = consumer.next
    expect(games).not_to be_empty
    expect(games.size).to eq(30)
    expect(consumer.page).to eq(1)
  end
end

require 'rails_helper'

describe PlayStation::Game do
  context 'Game not published' do
    it 'has current price nil' do
      expect(game.price).to be_nil
    end

    it 'is not published' do
      expect(game).not_to be_published
    end
  end

  context 'Game with discount' do
    subject(:game) { described_class.new(JSON.parse(open(Rails.root.join('spec/fixtures/games/ps4_last_blade2.json')).read)) }

    it 'has current price with discount' do
      expect(game.price.to_i).to eq(124)
    end
  end

  context 'Last Blade 2' do
    subject(:game) { described_class.new(JSON.parse(open(Rails.root.join('spec/fixtures/games/ps4_last_blade2.json')).read)) }

    it 'has current price without plus discount' do
      expect(game.ps_plus_price).to eq(56)
    end

    it 'has current price' do
      expect(game.price.to_i).to eq(63)
    end

    it 'is published' do
      expect(game).to be_published
    end
  end

  context 'Battlefield 4' do
    subject(:game) { described_class.new(JSON.parse(open(Rails.root.join('spec/fixtures/games/ps_battlefield4.json')).read)) }

    it 'has title' do
      expect(game.name).to eq('Battlefield 4™')
    end

    it 'has current price' do
      expect(game.price.to_i).to eq(124)
    end

    it 'has no playstation plus price' do
      expect(game.ps_plus_price).to be_nil
    end

    it 'has id' do
      expect(game.id).to eq('EP0006-CUSA00049_00-BATTLEFIELD40000')
    end

    it 'has description' do
      expect(game.description).to be_present
    end

    it 'has playstation store url' do
      expect(game.url).to eq('https://store.playstation.com/#!/en-pl/games/battlefield-4-premium-edition/cid=EP0006-CUSA00049_00-BF4PREMIUMEDITIO')
    end

    it 'has main poster' do
      expect(game.poster_url).to eq('http://apollo2.dl.playstation.net/cdn/EP0006/CUSA00049_00/ICcPzCS2XUjvKTCFJ6VIXpZrqF99NUSG.png')
    end

    it 'has background' do
      expect(game.background_url).to eq('http://apollo2.dl.playstation.net/cdn/EP0006/CUSA00049_00/igWongSLd6SU5M8mLM2r9NyLL506oWew.jpg')
    end

    it 'has screenshoots' do
      expect(game.screenshoots).not_to be_empty
      expect(game.screenshoots.size).to eq(5)
      expect(game.screenshoots[0]).to eq('https://apollo2.dl.playstation.net//cdn//EP0006//CUSA00049_00//FREE_CONTENTI3EuUf72Ivqtk04foHEv//PREVIEW_SCREENSHOT5_416515.jpg')
    end

    it 'is published' do
      expect(game).to be_published
    end
  end
end

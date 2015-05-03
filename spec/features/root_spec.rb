require 'rails_helper'

RSpec.feature 'Creating a deck and adding some cards' do
  before do
    page.driver.browser.basic_authorize('covermymeds', 'draft2015')
  end

  let(:deckname) { "deckname-#{SecureRandom.hex}" }
  let(:set_1) { "set_1-#{SecureRandom.hex}" }
  let(:set_2) { "set_2-#{SecureRandom.hex}" }
  let(:type) { Type.find_or_create_by!(name: 'Land') }

  let!(:card) do
    card = Card.where(mana_cost: '1UG',
                      name: "card-#{SecureRandom.hex}",
                      number: 1,
                      cmc: 1,
                      set: set_1).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:swamp) do
    card = Card.where(mana_cost: '',
               name: 'Swamp',
               number: 101,
               cmc: 0,
               set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:plains) do
    card = Card.where(mana_cost: '',
               name: 'Plains',
               number: 102,
               cmc: 0,
               set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:island) do
    card = Card.where(mana_cost: '',
               name: 'Island',
               number: 103,
               cmc: 0,
               set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:mountain) do
    card = Card.where(mana_cost: '',
               name: 'Mountain',
               number: 104,
               cmc: 0,
               set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:forest) do
    card = Card.where(mana_cost: '',
               name: 'Forest',
               number: 100,
               cmc: 0,
               set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  let!(:other_card) do
    card = Card.where(name: "other_card-#{SecureRandom.hex}",
                      number: 2,
                      cmc: 2,
                      mana_cost: '2GB',
                      set: set_2).first_or_create!

    CardType.create!(card: card, type: type)

    card
  end

  scenario "Create a deck and add a card" do
    visit '/'

    expect(page).to have_content 'MtG Draft Master'

    fill_in 'deck_name', with: deckname
    click_on 'Create Deck'

    expect(page).to have_content deckname

    fill_in 'card_number', with: card.number
    select card.set, from: 'card_set'
    click_on 'Add Card'

    expect(page).to have_content card.name
    expect(page).to have_content card.mana_cost
  end

  describe "Default card set" do
    before do
      visit '/'
      fill_in 'deck_name', with: deckname
      click_on 'Create Deck'
    end

    scenario "when a card has just been selected" do
      fill_in 'card_number', with: card.number
      select card.set, from: 'card_set'
      click_on 'Add Card'

      expect(page.has_select?('card_set', selected: card.set)).to be_truthy
    end
  end

  describe "Easily adding lands" do
    before do
      visit '/'
      fill_in 'deck_name', with: deckname
      click_on 'Create Deck'
    end

    scenario "adding lands easily" do
      click_on 'Add Forest'
      click_on 'Add Island'
      click_on 'Add Mountain'
      click_on 'Add Swamp'
      click_on 'Add Plains'

      expect(page).to have_content 'Forest'
      expect(page).to have_content 'Island'
      expect(page).to have_content 'Plains'
      expect(page).to have_content 'Swamp'
      expect(page).to have_content 'Mountain'
    end
  end
end

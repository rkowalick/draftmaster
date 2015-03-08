require 'rails_helper'

RSpec.describe Deck, type: :model do
  it { should have_many(:card_decks) }
  it { should have_many(:cards).through(:card_decks) }
end
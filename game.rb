require_relative 'methods.rb'
require 'pry'

#practice decks
deck1 = ["A", 2, 3,4,5,4,3,5,4,3]
deck2 = ["K", 2,3,4,5,6,7,4,6,7,5,6]
deck3 = [2,3,"A",4,5,5,8,9,7,5,3]
deck4 = [2,3,4,5,5,6,7,4,4,5,5,5]

welcome
deck = shuffle_deck
print "The Shuffled Deck:"
print deck
puts
deal_to_player(deck)
player_turn
dealer_begin
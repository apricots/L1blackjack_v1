@bust_number = 21
@dealer_limit = 17

# creates a deck of cards
def make_deck
  # create empty deck
  deck = []
  # add "special value" cards
  4.times {deck.push("A")}
  4.times {deck.push("J")}
  4.times {deck.push("Q")}
  4.times {deck.push("K")}
  # add face value cards
  for i in 2..10
    4.times {deck.push(i)}
  end
  return deck
end

# uses make_deck to create a deck of cards and also shuffle them
def shuffle_deck
  #creates deck
  original_deck = make_deck
  # create new array to store shuffled deck
  $shuffled_deck = []
  # cards remaining in original deck
  count = 52
  # while there are still some cards remaining in the deck...
  while count > 0
    index = rand(count)
    $shuffled_deck.push(original_deck[index])
    original_deck.delete_at(index)
    #update count to reflect number of cards left in original deck
    count = count - 1
  end
  return $shuffled_deck
end

# deals two cards of shuffled deck to the player
def deal_to_player(deck)
  # selects first two cards from the shuffled deck
  card_1 = deck[0]
  card_2 = deck[1]
  # create new variable to keep track of what card you are on
  $card_number = 2
  $player_cards = []
  $player_cards.push(card_1)
  $player_cards.push(card_2)
  say "Welcome, #{$name}! Your first card is '#{card_1}' and your second card is '#{card_2}'"
  check_and_total
  if $win
    say "YOU WIN!!!!"
    abort
  end
end

# check and total for player!
def check_and_total
  if check_a($player_cards)
    total1 = calculate($player_cards)
    total2 = calculate_with_ace($player_cards)
    # if both values are not bust!
    if total1 <= 21 && total2 <= 21
      say "You have a total of either #{total1} or #{total2}"
      $final = total1
    else
      say "You have a total of #{total2}"
      $final = total2
    end
  else
    total = calculate($player_cards)
    say "You have a total of #{total}"
    $final = total
  end

  if total1 == @bust_number || total2 == @bust_number || total == @bust_number
    $win = true
  end

  #check if busted
  if total1.to_i > @bust_number && total2.to_i > @bust_number
    $bust = true
  elsif total.to_i > @bust_number
    $bust = true
  else
    $bust = false
  end
end

# check and total for dealer!
def dealer_check_and_total
  if check_a($dealer_cards)
    total1 = calculate($dealer_cards)
    total2 = calculate_with_ace($dealer_cards)
    # if both values are not bust!
    if total1 <= 21 && total2 <= 21
      say "The dealer has a total of either #{total1} or #{total2}"
      $final_dealer = total1
    else
      say "The dealer has a total of #{total2}"
      $final_dealer = total2
    end
  else
    total = calculate($dealer_cards)
    say "The dealer has a total of #{total}"
    $final_dealer = total
  end

  if total1 == @bust_number || total2 == @bust_number || total == @bust_number
    $lose = true
  end

  if $final_dealer > $final && !$bust
    $lose = true
  end

  #check if busted
  if total1.to_i > @bust_number && total2.to_i > @bust_number
    $bust = true
  elsif total.to_i > @bust_number
    $bust = true
  else
    $bust = false
  end
end


# for all computer talking to user
def say string
  puts "=> " + string
end

def welcome
  say "Hi there! What is your name?"
  $name = gets.chomp
end

def player_turn
  say "Would you like to hit or stay?"
end

# method to calculate the sum of the cards.. with ACE = 11
def calculate(cards_on_table)
  total = 0
  cards_on_table.each do |card|
      if card == "J" || card == "Q" || card == "K"
        total = total + 10
      elsif card == "A"
        total = total + 11
      else
        total = total + card
      end
    end
  return total
end

# when ACE = 1
def calculate_with_ace(cards_on_table)
  total = 0
  cards_on_table.each do |card|
      if card == "J" || card == "Q" || card == "K"
        total = total + 10
      elsif card == "A"
        total = total + 1
      else
        total = total + card
      end
    end
  return total
end

#checks cards to see if there are any Aces
def check_a(array)
  if array.include? 'A'
    true
  else
    false
  end
end

# player can HIT until they bust or STAY on their turn
def player_turn
  say "It's your turn. Would you like to HIT or STAY?"
  response = gets.chomp
  # if user wants to HIT
  if response.upcase == "HIT"
    puts
    say "Okay, you said HIT right? Hand before hit:"
    print $player_cards
    puts
    #check_a($player_cards)
    # get the next card from the shuffled deck and adds it to player's hand
    next_card = $shuffled_deck[$card_number]
    $player_cards.push(next_card)    
    #update which card number user is on
    $card_number = $card_number + 1

    say "These are your new cards!"
    print $player_cards
    say "#{$name}, your next card was a #{next_card}."
    # check if there are Aces, and total up cards
    check_and_total
    # check if busted
    if $bust
      say "GAME OVER! You busted!"
      abort
    elsif $win
      say "YOU WIN!!!"
      abort
    else
      player_turn
    end
    puts
    puts
  # if user wants to STAY!
  elsif response.upcase == "STAY"
    puts
    say "Okay. You would like to STAY with #{$final}."
    say "It is the Dealer's Turn now!"
  # else
  #   puts
  #   say "I don't understand. Can you please repeat that?"
  #   player_turn
  end
end

def update_card
  $card_number = $card_number + 1
end

# dealer's turn begins after player finishes
def dealer_begin
  # selects next two cards from the shuffled deck
  card_1 = $shuffled_deck[$card_number]
  update_card
  card_2 = $shuffled_deck[$card_number]
  update_card
  # keep track of dealer's cards
  $dealer_cards = []
  $dealer_cards.push(card_1)
  $dealer_cards.push(card_2)
  say "Dealer's cards are '#{card_1}' and '#{card_2}'"
  dealer_check_and_total
  # check if the dealer has busted
  if $bust
    say "The dealer has BUSTED! You win :)"
  # check if dealer has won (reached 21 on first round)
  elsif $lose
    say "Sorry, you lost :("
  else
    dealer_turn
  end
end

# dealer gets next card
def dealer_hit
  say "Dealer is taking another card!"
  next_card = $shuffled_deck[$card_number]
  $dealer_cards.push(next_card)
  update_card
  say "Dealer received a #{next_card}!"
end

# if dealer has under 17 points, they must keep hitting
def dealer_turn
  print "This is what the dealer has currently:"
  puts $final_dealer


  while $final_dealer < @dealer_limit do
    dealer_hit
    print $dealer_cards
    puts
    dealer_check_and_total
  end

  while $final_dealer <= $final && $final_dealer >= @dealer_limit do
    dealer_hit
    print $dealer_cards
    puts
    dealer_check_and_total
  end


  if $bust
    say "The dealer has BUSTED! You win :)"
  # check if dealer has won (reached 21 on first round)
  elsif $lose
    say "Sorry, you lost :("
  else
    dealer_turn
  end

end


















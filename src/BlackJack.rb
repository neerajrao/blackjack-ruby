$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Dealer'
require 'Player'
require 'Constants'

=begin rdoc
House rules:
* Blackjack wins 3:2
* Dealer stands at 17
* Double-down only on first two cards
* Double-down limited to 100% of bet
* Splits allowed on same value cards
* Resplits allowed up to 4 hands

Most code is written to be self-documenting.
=end

def start_game
    puts "Playing Blackjack...\n\n"
    print_house_rules

    numPlayers = prompt_for_number_of_players

    # init players
    players = (1..numPlayers).map{|position| Player.new(position, INIT_MONEY)}

    # Pass dealer a reference to the players and let him start the game
    Dealer.new(players).play_game
end

def prompt_for_number_of_players
    numPlayers = 0
    loop do
        puts "How many players are playing?"
        numPlayers = gets.chomp.to_i
        break if(numPlayers > 0 && numPlayers <= MAX_PLAYERS)
        puts "Number of players must be between 1 and #{MAX_PLAYERS}. Please try again..."
    end
    puts ""
    return numPlayers
end

def print_house_rules
    puts HOUSE_RULES
end

if __FILE__ == $0
    start_game
end

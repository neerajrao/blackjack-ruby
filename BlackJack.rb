require 'Dealer'
require 'Player'

MAX_PLAYERS = 7
INIT_MONEY = 1000

def start_game
    puts "Playing Blackjack..."

    # get number of players
    numPlayers = 0
    loop do
        puts "How many players are playing?"
        numPlayers = gets.chomp.to_i
        break if(numPlayers > 0 && numPlayers <= MAX_PLAYERS)
        puts "Number of players must be between 1 and #{MAX_PLAYERS}. Please try again..."
    end

    # init players array
    players = (1..numPlayers).collect{|position| Player.new(position, INIT_MONEY)}

    # Pass dealer a ref to the players and let him start the game
    Dealer.new(players).start_game
end

if __FILE__ == $0
    start_game
end

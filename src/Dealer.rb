$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Deck'
require 'Constants'
include Constants

=begin rdoc
Code is written to be self-documenting.

This class represents the Blackjack dealer and, as such, implements
the Blackjack game algorithm. We choose to separate the Player and
Dealer classes because, logically, it is the dealer that implements
the Blackjack control flow and algorithm whereas the Players just
respond to the dealer and make decisions about what move to make next
based on their hands and their money.

Like a +Player+, the +Dealer+ also has a hand. However, the dealer is only
limited to a single hand unlike a Player who may have more than one
hands resulting from a split.

The +play_round+ function implements the game algorithm. A brief outline follows:
* for each round of the game
    * each player and the dealer himself start out with a clean hand (i.e., no cards
      and no bets)
    * the dealer asks each player to place a bet on their hand
    * the dealer deals out two initial cards to each player
    * the dealer deals himself two initial cards
    * for each player and each hand, the dealer
        * asks the player to choose an action. The available actions depend on
          the bet placed on the hand, the cards in the hand and the amount
          of money the player has left.
        * updates the player's hand depending on the chosen action
    * the dealer then finishes dealing himself cards until he stands at 17
    * the dealer then settles any bets depending on the result
    * if there are still solvent players, the game can continue, provided the
      user wishes to
=end

class Dealer
    def initialize(players)
        @hand = Hand.new
        @deck = Deck.new
        @players = players
        @game_over = false
    end

    def play_game
        puts "Dealer is starting game...\n"
        play_round until @game_over
        puts "Game over. Thanks for playing!\n\n"
    end

    def play_round
        puts "\nStarting a new round..."
        puts "-------------------------\n\n"

        setup_round

        @players.each do |player|
            player.hands.each do |player_hand|
                process_player_hand(player, player_hand)
            end
        end

        deal_to_self unless @hand.is_blackjack?

        settle_bets_at_end_of_round

        retain_only_solvent_players_at_end_of_round

        @game_over = is_game_over?
    end

    # reset all hands
    # deal initial two cards to all players and to self (dealer)
    def setup_round
        reset_player_hands
        reset_self_hand

        @players.each do |player|
            puts ">>>> #{player}\n\n"
            player.hands.each do |player_hand|
                player.set_bet_on_hand(player_hand)
                deal_initial_cards_to_hand(player_hand)
                show_hand(player, player_hand)
            end
        end

        deal_initial_cards_to_hand(@hand)
        show_dealer_hand
        puts "Initial cards dealt\n\n\n\n"
    end

    def reset_player_hands
        @players.map{|player| player.reset_hands}
    end

    def reset_self_hand
        @hand.reset
    end

    def deal_initial_cards_to_hand(hand)
        2.times{deal_to_hand(hand)}
    end

    def show_dealer_hand
        show_hand(self, @hand)
    end

    def show_hand(player, hand)
        puts "#{player}'s hand:\n" +
             "------------------\n" +
             "#{hand}"
    end

    def process_player_hand(player, player_hand)
        puts ">>>> #{player}\n\n"
        show_hand(player, player_hand)
        show_dealer_hand

        # if player got blackjack, go on to next hand immediately
        if player_hand.is_blackjack?
            puts "#{player}, your hand got blackjack!\n\n"
            break
        end

        # ask player for moves
        valid_moves_map = build_valid_moves_map_for_hand(player, player_hand)
        move = player.prompt_for_move(valid_moves_map)

        if player_stands_with_move(move)
            return

        elsif player_doubles_down_with_move(move)
            puts "Doubling down on your hand"
            player.double_down_on_hand(player_hand)
            puts "Your bet is now #{player_hand.bet}; you have $#{player.money} left\n\n"
            deal_to_hand(player_hand)
            show_hand(player, player_hand)

        else
            if player_splits_with_move(move)
                puts "Splitting your hand. Resplits are allowed until you have "\
                     "#{MAX_HANDS_PER_PLAYER} hands in all."
                new_hand = player.split_hand(player_hand)

                deal_to_hand(player_hand)
                deal_to_hand(new_hand)

                puts "Here are the resulting split hands:\n\n"
                show_hand(player, player_hand)
                show_hand(player, new_hand)

            else #player hits
                deal_to_hand(player_hand)
            end

            if player_hand.is_bust?
                show_hand(player, player_hand)
                puts "Sorry, #{player}, your hand busted\n\n"
            else
                process_player_hand(player, player_hand)
            end
        end
    end

    def build_valid_moves_map_for_hand(player, hand)
        valid_moves_map = STAND_KEY_DESCR_MAP.merge(HIT_KEY_DESCR_MAP)
        valid_moves_map.merge!(DOUBLE_DOWN_KEY_DESCR_MAP) if player.can_double_down_with_hand?(hand)
        valid_moves_map.merge!(SPLIT_KEY_DESCR_MAP) if player.can_split_hand?(hand)
        return valid_moves_map
    end

    def player_stands_with_move(move)
        move == STAND_KEY
    end

    def player_doubles_down_with_move(move)
        move == DOUBLE_DOWN_KEY
    end

    def player_splits_with_move(move)
        move == SPLIT_KEY
    end

    def deal_to_self
        puts "Dealing to #{self}\n\n"
        until self.should_stand?
            deal_to_hand(@hand)
        end
        show_dealer_hand
    end

    def should_stand?
        @hand.value >= STAND_VALUE
    end

    def deal_to_hand(hand)
        card = @deck.pop
        hand.push(card)
    end

    def settle_bets_at_end_of_round
        @players.each do |player|
            player.hands.each do |player_hand|
                if player_hand.is_bust?
                    # player loses
                    puts "#{player} busted => #{player} loses"
                    puts "#{player} now has $#{player.money}\n\n"
                    break
                end

                winnings = 0
                if player_hand.is_blackjack?
                    if @hand.is_blackjack?
                        # both dealer and player have blackjack => tie
                        winnings = player_hand.bet
                        puts "#{self} and #{player} tie at blackjack "\
                             "=> #{player} gets $#{winnings} back"

                    else
                        # player has blackjack, dealer does not => player wins 3:2
                        winnings = player_hand.bet*BLACKJACK_PAYOFF
                        puts "#{player} has blackjack => #{player} wins $#{winnings}"
                    end

                else
                    if @hand.is_bust?
                        # dealer busted, player did not bust => player wins 1:1
                        winnings = player_hand.bet*NORMAL_PAYOFF
                        puts "#{self} busted, #{player} did not => #{player} wins $#{winnings}"

                    else
                        if player_hand.value == @hand.value
                            # both dealer and player have same points => tie
                            winnings = player_hand.bet
                            puts "#{self} and #{player} tie at #{player_hand.value} "\
                                 "=> #{player} gets $#{winnings} back"

                        elsif player_hand.value > @hand.value
                            # player wins 1:1
                            winnings = player_hand.bet*NORMAL_PAYOFF
                            puts "#{player} wins (#{player_hand.value} vs #{@hand.value}) "\
                                 "=> #{player} wins $#{winnings}"

                        else
                            # player loses
                            if @hand.is_blackjack?
                                puts "#{self} has blackjack => #{player} loses $#{player_hand.bet}"
                            else
                                puts "#{self} wins (#{@hand.value} vs #{player_hand.value})"\
                                     " => #{player} loses $#{player_hand.bet}"
                            end
                        end
                    end
                end

                player.money += winnings
                puts "#{player} now has $#{player.money}\n\n"
            end
        end
    end

    def retain_only_solvent_players_at_end_of_round
        @players = @players.select {|player| player.is_solvent?}
    end

    def is_game_over?
        return true if @players.empty?
        return ask_if_end_game
    end

    def ask_if_end_game
        play_another_round = ""
        loop do
            puts "Would you like to play another round? (y/n)"
            play_another_round = gets.chomp
            break if (play_another_round == "y" || play_another_round == "n")
            puts "Invalid choice. Please press either 'y' or 'n'."
        end
        puts

        if(play_another_round == "n")
            return true
        else
            return false
        end
    end

    def to_s
        "Dealer"
    end
end

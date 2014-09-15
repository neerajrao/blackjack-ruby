$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Deck'
require 'Constants'
include Constants

class Dealer
    def initialize(players)
        @hand = Hand.new # dealer always has only one hand
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

        reset_player_hands
        reset_self_hand
        deal_initial_cards_to_hand(@hand)

        @players.each do |player|
            puts ">>>> #{player}\n\n"
            player.hands.each do |player_hand|
                player.set_bet_on_hand(player_hand)

                deal_initial_cards_to_hand(player_hand)

                while true
                    show_hand(player, player_hand)

                    # if player got blackjack, go on to next hand immediately
                    if player_hand.is_blackjack?
                        puts "#{player}, your hand got blackjack!\n\n"
                        break
                    end

                    show_dealer_hand

                    # ask player for moves
                    valid_moves_map = build_valid_moves_map_for_hand(player, player_hand)
                    move = player.prompt_for_move(valid_moves_map)

                    if player_stands(move)
                        break

                    elsif player_doubles_down(move)
                        player.double_down_on_hand(player_hand)
                        deal_to_hand(player_hand)
                        show_hand(player, player_hand)
                        break

                    elsif player_splits(move)
                        new_hand = player.split_hand(player_hand)
                        deal_to_hand(player_hand)
                        deal_to_hand(new_hand)
                        show_hand(player, player_hand)
                        show_hand(player, new_hand)
                        break if player_hand.is_bust?

                    else #player hits
                        deal_to_hand(player_hand)
                        if player_hand.is_bust?
                            show_hand(player, player_hand)
                            puts "Sorry, #{player}, your hand busted\n\n"
                            break
                        end
                    end
                end
            end
        end

        deal_to_self unless @hand.is_blackjack?

        settle_bets_at_end_of_round

        retain_only_solvent_players_at_end_of_round

        @game_over = is_game_over?
    end

    def deal_initial_cards_to_hand(hand)
        2.times{deal_to_hand(hand)}
    end

    def deal_to_hand(hand)
        card = @deck.pop
        hand.push(card)
    end

    def build_valid_moves_map_for_hand(player, hand)
        valid_moves_map = STAND_KEY_DESCR_MAP.merge(HIT_KEY_DESCR_MAP)
        valid_moves_map.merge!(DOUBLE_DOWN_KEY_DESCR_MAP) if player.can_double_down_with_hand?(hand)
        valid_moves_map.merge!(SPLIT_KEY_DESCR_MAP) if player.can_split_hand?(hand)
        return valid_moves_map
    end

    def deal_to_self
        puts "Dealing to #{self}\n\n"
        until self.should_stand?
            deal_to_hand(@hand)
        end
        show_dealer_hand
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

    def show_dealer_hand
        show_hand(self, @hand)
    end

    def show_hand(player, hand)
        puts "#{player}'s hand:\n" +
             "------------------\n" +
             "#{hand}"
    end

    def retain_only_solvent_players_at_end_of_round
        @players = @players.select {|player| player.is_solvent?}
    end

    def reset_player_hands
        @players.map{|player| player.reset_hands}
    end

    def reset_self_hand
        @hand.reset
    end

    def should_stand?
        @hand.value >= STAND_VALUE
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

    def player_stands(move)
        move == STAND_KEY
    end

    def player_doubles_down(move)
        move == DOUBLE_DOWN_KEY
    end

    def player_splits(move)
        move == DOUBLE_DOWN_KEY
    end

    def to_s
        "Dealer"
    end
end

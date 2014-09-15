=begin rdoc
This module defines various constants used by the various
Blackjack classes.
=end
module Constants
    HOUSE_RULES = "House rules:\n" +
                  "------------\n" +
                  "  * No hole card\n" +
                  "  * Blackjack wins 3:2\n" +
                  "  * Dealer stands at 17\n" +
                  "  * Double-down only on first two cards\n" +
                  "  * Double-down limited to 100% of bet\n" +
                  "  * Splits allowed on same value cards\n" +
                  "  * Resplits allowed up to 4 hands\n\n"

    MAX_HANDS_PER_PLAYER = 4
    MAX_PLAYERS = 7
    INIT_MONEY = 1000 # start players out with this amount

    STAND_VALUE = 17
    BLACKJACK_VALUE = 21

    NORMAL_PAYOFF = 2
    BLACKJACK_PAYOFF = 2.5

    SUITS = ["♠", "♥", "♦", "♣"] # suits are technically of no importance, but we keep them for printing
    FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

    STAND_KEY = "s"
    STAND_KEY_DESCR_MAP = {STAND_KEY => "stand"}
    HIT_KEY = "h"
    HIT_KEY_DESCR_MAP = {HIT_KEY => "hit"}
    DOUBLE_DOWN_KEY = "d"
    DOUBLE_DOWN_KEY_DESCR_MAP = {DOUBLE_DOWN_KEY => "double down"}
    SPLIT_KEY = "sp"
    SPLIT_KEY_DESCR_MAP = {SPLIT_KEY => "split"}
end

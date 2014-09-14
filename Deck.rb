require 'Card'

=begin rdoc
A key assumption is a Deck has enough cards for the game to end.
=end
class Deck
    SUITS = ["♠", "♥", "♦", "♣"]
    FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

    def initialize
        @cards = create_52_card_deck()
        @cards.shuffle!
    end

    def create_52_card_deck
        SUITS.collect {|suit| FACES.collect {|face| Card.new(face, suit)}}
    end

    def to_s
        @cards.join(", ")
    end

    def empty?
        @cards.empty?
    end

    def reset
        initialize
    end

    def pop
        @cards.pop
    end
end

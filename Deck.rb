require 'Card'

class Deck
    SUITS = ["♠", "♥", "♦", "♣"]
    FACES = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]

    def initialize
        @cards = create_52_card_deck()
        @cards.shuffle!
    end

    def create_52_card_deck
        cards = []
        SUITS.each do |suit|
            FACES.each do |faceval|
                cards.push(Card.new(faceval, suit))
            end
        end
        return cards
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

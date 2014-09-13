class Hand
    def initialize
        @cards = []
        @value = 0
    end

    def to_s
        "Hand cards: #{@cards.join(', ')}\nHand value: #{@value}"
    end

    def push(card)
        @cards.push(card)
        @value += card.value
    end
end

$:.unshift("#{File.dirname(__FILE__)}") # add source directory to path
require 'Card'
require 'Constants'
include Constants

=begin rdoc
Code is written to be self-documenting.

Methods are named similary to Ruby built-ins so they are easy
to remember. E.g. pop to take a card from the deck

This class represents a playing card deck that the dealer deals
from. A key assumption is that a Deck has enough cards for the game
to end.
=end

class Deck
    attr_accessor :cards
    def initialize
        reset
    end

    def reset
        @cards = create_52_card_deck()
        @cards.shuffle!
    end

    def create_52_card_deck
        SUITS.map{|suit| FACES.map{|face| Card.new(face, suit)}}.flatten
    end

    def to_s
        @cards.join(", ")
    end

    def empty?
        @cards.empty?
    end

    # if deck is empty, re-init the deck. This way, the deck never runs out of cards
    def pop
        reset if empty?
        @cards.pop
    end
end

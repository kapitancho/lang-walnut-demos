module demo-err5:

/* Test for invalid enumeration value */
Suit = :[Spades, Hearts, Diamonds, Clubs];

BlackSuit = Suit[Spades, Clubs, Joker];

main = ^Any => String :: 'Hello World!';
module demo-err7:

/* Test for invalid enumeration value */
Suit := (Spades, Hearts, Diamonds, Clubs);

main = ^Any => String :: {Suit.Joker}->printed;
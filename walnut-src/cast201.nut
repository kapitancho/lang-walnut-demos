module cast201:

Reverser = ^String => String;

myReverse = ^String => String :: #->reverse;

Suit = :[Spade, Heart, Diamond, Club];
SuitColor = :[Red, Black];

Suit->color(^Null => SuitColor) :: ?whenValueOf($) is {
    Suit.Heart: SuitColor.Red,
    Suit.Diamond: SuitColor.Red,
    ~: SuitColor.Black
};

Suit->name(^Null => String) :: $->textValue;
Suit->secretName(^Null => String) %% Reverser :: %($->textValue);

Encoder = $[value: String];
Encoder(String) :: [value: #->reverse];

Decoder = $[value: String];
Decoder(String) %% Reverser :: [value: %(#)];

recGlobal = ^Integer => String :: ?whenIsTrue { # > 0 : '*'->concat(recGlobal(# - 1)), ~ : '' };

myFn = ^Array<String> => Any :: {
    a = Suit.Spade;
    recLocal = ^Integer => String :: ?whenIsTrue { # > 0 : '*'->concat(recLocal(# - 1)), ~ : '' };
    [
        a,
        a->textValue,
        a->name,
        a->secretName,
        a->color,
        Encoder('hello'),
        Decoder('hello'),
        recGlobal(3),
        recLocal(5)
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
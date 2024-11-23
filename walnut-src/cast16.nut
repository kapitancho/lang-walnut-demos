module cast16:

Suit = :[Spade, Heart, Diamond, Club];
Apple = [asText: ^Null => String];
Suit ==> Apple :: [
    asText: ^Null => String :: {
        {$->textValue}->concat(' suit')
    }
];

myFn = ^Array<String> => Any :: {
    a = Suit.Spade;
    t = type{Suit};
    [
        a,
        a->textValue,
        a->as(type{Apple}).asText(),
        a->type,
        t->values,
        a->type->values,
        t->valueWithName('Heart'),
        t->valueWithName('Mario')
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
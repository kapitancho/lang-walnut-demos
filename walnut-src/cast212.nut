module cast212:

IntegerMonad = ^Integer => Integer;

timesTwo = ^Integer => Integer :: # * 2;
plusOne = ^Integer => Integer :: # + 1;
squared = ^Integer => Integer :: # * #;

composed = ^Integer => Integer :: [timesTwo, plusOne, squared]->chainInvoke(#);

NotAnInteger = :[];
dividedByThree = ^Integer => Result<Integer, NotAnInteger> :: ?whenIsTrue {
    {# % 3} == 0: {# / 3}->asInteger,
    ~: Error(NotAnInteger[])
};

PartialMonad = ^Integer => Result<Integer, NotAnInteger>;
BrokenMonad = ^Result<Integer, NotAnInteger> => Result<Integer, NotAnInteger>;
monadFixer = ^PartialMonad => BrokenMonad :: {
    monad = #;
    ^Result<Integer, NotAnInteger> => Result<Integer, NotAnInteger> :: ?whenTypeOf(#) is {
        type{Integer}: ?noError(monad(#)),
        type{Result<Nothing, NotAnInteger>}: #
    }
};

brokenComposed = ^Integer => Result<Integer, NotAnInteger> :: [
    timesTwo, plusOne, dividedByThree, squared
]->map(monadFixer)->chainInvoke(#);

myFn = ^Array<String> => Any :: [
    composed(3), composed(4), composed(5),
    brokenComposed(3), brokenComposed(4),
    brokenComposed(5), brokenComposed(6),
    brokenComposed(7), brokenComposed(8),
    brokenComposed(9), brokenComposed(10)
];

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
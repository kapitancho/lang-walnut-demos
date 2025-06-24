module demo-asstring:

Suit := (Spades, Hearts, Diamonds, Clubs);
NoGreeting := ();
Message := $[text: String];
Greeting := $[text: String];

Message ==> String :: $text;
Greeting ==> String :: $text;

fromBoolean         = ^Boolean                 => String['true', 'false']          :: #->asString;
fromTrue            = ^True                    => String['true']                   :: #->asString;
fromFalse           = ^False                   => String['false']                  :: #->asString;
fromNull            = ^Null                    => String['null']                   :: #->asString;
fromIntegerSubset   = ^Integer[1, -3, 12]      => String['1', '-3', '12']          :: #->asString;
fromIntegerRange    = ^Integer<1..4>           => String<1>                        :: #->asString;
fromInteger         = ^Integer                 => String                           :: #->asString;
fromRealSubset      = ^Real[1.9, -3.14, 12]    => String['1.9', '-3.14', '12']     :: #->asString;
fromRealRange       = ^Real<1.9..4.2>          => String<1..>                      :: #->asString;
fromReal            = ^Real                    => String                           :: #->asString;
fromStringSubset    = ^String['a', 'b', 'c']   => String['a', 'b', 'c']            :: #->asString;
fromStringRange     = ^String<2..5>            => String<2..5>                     :: #->asString;
fromString          = ^String                  => String                           :: #->asString;
fromAtom            = ^NoGreeting              => String['NoGreeting']             :: #->asString;
fromEnumSubset      = ^Suit[Spades, Hearts]    => String['Spades', 'Hearts']       :: #->asString;
fromEnum            = ^Suit                    => String['Spades', 'Hearts', 'Diamonds', 'Clubs'] :: #->asString;
fromMutable         = ^Mutable<Integer<5..20>> => String<1..2>                     :: #->asString;
fromType            = ^Type                    => String                           :: #->asString;

fromOpen            = ^Message                 => String                           :: #->asString;
fromSealed          = ^Greeting                => String                           :: #->asString;
fromAny             = ^Any                     => Result<String, CastNotAvailable> :: #->asString;

test = ^Null => Map :: [
    fromBoolean: fromBoolean(true),
    fromTrue: fromTrue(true),
    fromFalse: fromFalse(false),
    fromNull: fromNull(null),
    fromIntegerSubset: fromIntegerSubset(12),
    fromIntegerRange: fromIntegerRange(4),
    fromInteger: fromInteger(42),
    fromRealSubset: fromRealSubset(12),
    fromRealRange: fromRealRange(4.2),
    fromReal: fromReal(3.14),
    fromStringSubset: fromStringSubset('b'),
    fromStringRange: fromStringRange('hello'),
    fromString: fromString('world'),
    fromAtom: fromAtom(NoGreeting),
    fromEnumSubset: fromEnumSubset(Suit.Hearts),
    fromEnum: fromEnum(Suit.Clubs),
    fromMutable: fromMutable(mutable{Integer<5..20>, 7}),
    fromType: fromType(type{Integer}),
    fromOpen: fromOpen(Message[text: 'hello']),
    fromSealed: fromSealed(Greeting[text: 'hello']),
    fromAnyOk: fromAny(42),
    fromAnyError: fromAny([]),
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test();
    x->printed
};
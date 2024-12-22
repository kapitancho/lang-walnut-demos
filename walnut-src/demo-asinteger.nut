module demo-asinteger:

Percentage <: Integer<0..100>;
Greeting = $[text: String];

Greeting ==> Integer :: $text->length;

fromBoolean         = ^Boolean                 => Integer[0, 1]                     :: #->asInteger;
fromTrue            = ^True                    => Integer[1]                        :: #->asInteger;
fromFalse           = ^False                   => Integer[0]                        :: #->asInteger;
fromNull            = ^Null                    => Integer[0]                        :: #->asInteger;
fromIntegerSubset   = ^Integer[1, -3, 12]      => Integer[1, -3, 12]                :: #->asInteger;
fromIntegerRange    = ^Integer<1..4>           => Integer<1..4>                     :: #->asInteger;
fromInteger         = ^Integer                 => Integer                           :: #->asInteger;
fromRealSubset      = ^Real[1.9, -3.14, 12]    => Integer[1, -3, 12]                :: #->asInteger;
fromRealRange       = ^Real<1.9..4.2>          => Integer<1..4>                     :: #->asInteger;
fromReal            = ^Real                    => Integer                           :: #->asInteger;
fromStringSubset    = ^String['a', '2', 'c']   => Result<Integer, NotANumber>       :: #->asInteger;
fromStringRange     = ^String<2..5>            => Result<Integer, NotANumber>       :: #->asInteger;
fromString          = ^String                  => Result<Integer, NotANumber>       :: #->asInteger;
fromMutableInteger  = ^Mutable<Integer<5..20>> => Integer<5..20>                    :: #->asInteger;
fromMutableReal     = ^Mutable<Real<5..20>>    => Integer<5..20>                    :: #->asInteger;
fromSubtype         = ^Percentage              => Integer<0..100>                   :: #->asInteger;

fromSealed          = ^Greeting                => Integer                           :: #->asInteger;

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
    fromStringSubset: fromStringSubset('2'),
    fromStringRange: fromStringRange('15'),
    fromString: fromString('world'),
    fromMutableInteger: fromMutableInteger(mutable{Integer<5..20>, 7}),
    fromMutableReal: fromMutableReal(mutable{Real<5..20>, 7.29}),
    fromSubtype: fromSubtype(Percentage(35)),
    fromSealed: fromSealed(Greeting[text: 'hello']),
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test();
    x->printed
};
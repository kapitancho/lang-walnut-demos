module demo-asreal:

Message := #[text: String];
Greeting := $[text: String];

Message ==> Real :: $text->length;
Greeting ==> Real :: $text->length;

fromBoolean         = ^Boolean                 => Real[0, 1]                     :: #->asReal;
fromTrue            = ^True                    => Real[1]                        :: #->asReal;
fromFalse           = ^False                   => Real[0]                        :: #->asReal;
fromNull            = ^Null                    => Real[0]                        :: #->asReal;
fromIntegerSubset   = ^Integer[1, -3, 12]      => Real[1, -3, 12]                :: #->asReal;
fromIntegerRange    = ^Integer<1..4>           => Real<1..4>                     :: #->asReal;
fromInteger         = ^Integer                 => Real                           :: #->asReal;
fromRealSubset      = ^Real[1.9, -3.14, 12]    => Real[1.9, -3.14, 12]           :: #->asReal;
fromRealRange       = ^Real<1.9..4.2>          => Real<1.9..4.2>                 :: #->asReal;
fromReal            = ^Real                    => Real                           :: #->asReal;
fromStringSubset    = ^String['a', '2', 'c']   => Result<Real, NotANumber>       :: #->asReal;
fromStringRange     = ^String<2..5>            => Result<Real, NotANumber>       :: #->asReal;
fromString          = ^String                  => Result<Real, NotANumber>       :: #->asReal;
fromMutableInteger  = ^Mutable<Integer<5..20>> => Real<5..20>                    :: #->asReal;
fromMutableReal     = ^Mutable<Real<5..20>>    => Real<5..20>                    :: #->asReal;

fromOpen            = ^Message                 => Real                           :: #->asReal;
fromSealed          = ^Greeting                => Real                           :: #->asReal;

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
    fromOpen: fromOpen(Message[text: 'hello']),
    fromSealed: fromSealed(Greeting[text: 'hello']),
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test();
    x->printed
};
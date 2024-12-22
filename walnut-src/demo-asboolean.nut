module demo-asboolean:

IsSuccessful <: Boolean;
Greeting = $[text: String];

Greeting ==> Boolean :: {$text->length} == 'hello';

fromBoolean         = ^Boolean                 => Boolean                        :: #->asBoolean;
fromTrue            = ^True                    => True                           :: #->asBoolean;
fromFalse           = ^False                   => False                          :: #->asBoolean;
fromNull            = ^Null                    => False                          :: #->asBoolean;
fromIntegerSubset   = ^Integer[1, -3, 12]      => Boolean                        :: #->asBoolean;
fromIntegerRange    = ^Integer<1..4>           => Boolean                        :: #->asBoolean;
fromInteger         = ^Integer                 => Boolean                        :: #->asBoolean;
fromRealSubset      = ^Real[1.9, -3.14, 12]    => Boolean                        :: #->asBoolean;
fromRealRange       = ^Real<1.9..4.2>          => Boolean                        :: #->asBoolean;
fromReal            = ^Real                    => Boolean                        :: #->asBoolean;
fromStringSubset    = ^String['a', '2', 'c']   => True                           :: #->asBoolean;
fromStringRange     = ^String<2..5>            => True                           :: #->asBoolean;
fromString          = ^String                  => Boolean                        :: #->asBoolean;
fromMutableInteger  = ^Mutable<Integer<5..20>> => True                           :: #->asBoolean;
fromMutableReal     = ^Mutable<Real<5..20>>    => True                           :: #->asBoolean;
fromSubtype         = ^IsSuccessful            => Boolean                        :: #->asBoolean;

fromSealed          = ^Greeting                => Boolean                           :: #->asBoolean;

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
    fromSubtype: fromSubtype(IsSuccessful(false)),
    fromSealed: fromSealed(Greeting[text: 'hello']),
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test();
    x->printed
};
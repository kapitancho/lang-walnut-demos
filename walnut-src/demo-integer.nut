module demo-integer:

MyInteger <: Integer<4..12>;

/* string specific Integer->... */
binaryPlus          = ^[Integer<4..12>, Integer<-5..7>]     => Integer<-1..19>              :: #.0 + #.1;
binaryMinus         = ^[Integer<4..12>, Integer<-5..7>]     => Integer<-3..17>              :: #.0 - #.1;
binaryMultiply      = ^[Integer<4..12>, Integer<-5..7>]     => Integer                      :: #.0 * #.1;
binaryIntegerDivide = ^[Integer<4..12>, Integer<-5..7>]     => Result<Real, NotANumber>     :: #.0->binaryIntegerDivide(#.1);
binaryDivide        = ^[Integer<4..12>, Integer<-5..7>]     => Result<Real, NotANumber>     :: #.0 / #.1;
binaryModulo        = ^[Integer<4..12>, Integer<-5..7>]     => Result<Integer, NotANumber>  :: #.0 % #.1;
binaryPower         = ^[Integer<4..12>, Integer<-5..7>]     => Integer                      :: #.0->binaryPower(#.1); /*#.0 ** #.1;*/
unaryPlus           = ^Integer<-3..8>                       => Integer<-3..8>               :: #->unaryPlus;
unaryMinus          = ^Integer<-3..8>                       => Integer<-8..3>               :: #->unaryMinus;
upTo                = ^[Integer<2..5>, Integer<7..15>]      => Array<Integer<2..15>, 3..14> :: #.0->upTo(#.1);
downTo              = ^[Integer<7..15>, Integer<2..5>]      => Array<Integer<2..15>, 3..14> :: #.0->downTo(#.1);
unaryBitwiseNot     = ^Integer<0..8>                        => Integer<0..>                 :: #->unaryBitwiseNot;
binaryBitwiseAnd    = ^[Integer<0..20>, Integer<7..22>]    => Integer<0..20>                :: #.0->binaryBitwiseAnd(#.1);
binaryBitwiseOr     = ^[Integer<0..20>, Integer<7..22>]    => Integer<7..44>                :: #.0->binaryBitwiseOr(#.1);
binaryBitwiseXor    = ^[Integer<0..20>, Integer<7..22>]    => Integer<0..44>                :: #.0->binaryBitwiseXor(#.1);
abs                 = ^Integer<-120..70>                    => Integer<0..120>              :: #->abs;

binaryGreaterThan   = ^[Integer<4..12>, Integer<-5..7>]      => Boolean                      :: #.0 > #.1;
binaryGreaterThanEqual = ^[Integer<4..12>, Integer<-5..7>]      => Boolean                      :: #.0->binaryGreaterThanEqual(#.1); /*#.0 >= #.1;*/
binaryLessThan      = ^[Integer<4..12>, Integer<-5..7>]      => Boolean                      :: #.0 < #.1;
binaryLessThanEqual = ^[Integer<4..12>, Integer<-5..7>]      => Boolean                      :: #.0->binaryLessThanEqual(#.1); /* #.0 <= #.1;*/
/* common Any->... */
binaryEqual         = ^[Integer<2..15>, Integer<..10>]      => Boolean                      :: #.0 == #.1;
binaryNotEqual      = ^[Integer<2..15>, Integer<..10>]      => Boolean                      :: #.0 != #.1;
asString            = ^Integer<1..15>                       => String                       :: #->asString;
asReal              = ^Integer<1..15>                       => Real<1..15>                  :: #->asReal;
asBoolean           = ^Integer<-2..15>                      => Boolean                      :: #->asBoolean;
valueType           = ^Integer<1..15>                       => Type<Integer<1..15>>         :: #->type;
isOfType            = ^[Integer<1..15>, Type]               => Boolean                      :: #.0->isOfType(#.1);
jsonStringify       = ^Integer<1..15>                       => String                       :: #->jsonStringify;

test = ^[a: Integer<7..10>, b: Integer<..5>, c: Integer[3, 8], d: Integer<4..5>, e: MyInteger, f: Integer<-20..20>] => Map :: [
    binaryPlus: binaryPlus[#.a, #.d],
    binaryMinus: binaryMinus[#.a, #.d],
    binaryMultiply: binaryMultiply[#.a, #.d],
    binaryDivide: binaryDivide[#.a, #.d],
    binaryDivideZero: binaryDivide[#.a, 0],
    binaryIntegerDivide: binaryIntegerDivide[#.a, #.d],
    binaryIntegerDivideZero: binaryIntegerDivide[#.a, 0],
    binaryModulo: binaryModulo[#.a, #.d],
    binaryModuloZero: binaryModulo[#.a, 0],
    binaryPower: binaryPower[#.a, #.d],
    binaryGreaterThanTrue: binaryGreaterThan[#.a, #.d],
    binaryGreaterThanSame: binaryGreaterThan[#.a, 7],
    binaryGreaterThanFalse: binaryGreaterThan[4, 7],
    binaryGreaterThanEqualTrue: binaryGreaterThanEqual[#.a, #.d],
    binaryGreaterThanEqualSame: binaryGreaterThanEqual[#.a, 7],
    binaryGreaterThanEqualFalse: binaryGreaterThanEqual[4, 7],
    binaryLessThanTrue: binaryLessThan[#.a, #.d],
    binaryLessThanSame: binaryLessThan[#.a, 7],
    binaryLessThanFalse: binaryLessThan[4, 7],
    binaryLessThanEqualTrue: binaryLessThanEqual[#.a, #.d],
    binaryLessThanEqualSame: binaryLessThanEqual[#.a, 7],
    binaryLessThanEqualFalse: binaryLessThanEqual[4, 7],
    unaryPlus: unaryPlus(#.c),
    unaryMinus: unaryMinus(#.c),
    upTo: upTo[#.d, #.a],
    downTo: downTo[#.a, #.d],
    unaryBitwiseNot: unaryBitwiseNot(#.c),
    binaryBitwiseAnd: binaryBitwiseAnd[#.d, #.a],
    binaryBitwiseOr: binaryBitwiseOr[#.d, #.a],
    binaryBitwiseXor: binaryBitwiseXor[#.d, #.a],
    absPlus: abs(#.e),
    absMinus: abs(#.f),
    asString: asString(#.a),
    asReal: asReal(#.e),
    asBooleanTrue: asBoolean(#.a),
    asBooleanFalse: asBoolean(0),
    type: valueType(#.a),
    isOfTypeTrue: isOfType[#.a, type{Integer}],
    isOfTypeTrueInteger: isOfType[#.a, type{Integer}],
    isOfTypeFalse: isOfType[#.a, type{String}],
    binaryEqualTrue: binaryEqual[#.d, 5],
    binaryEqualFalse: binaryEqual[#.a, #.b],
    binaryNotEqualTrue: binaryNotEqual[#.a, #.b],
    binaryNotEqualFalse: binaryNotEqual[#.d, 5],
    jsonStringify: jsonStringify(#.c),
    myInteger: #.e,
    myIntegerBaseValue: #.e->baseValue,
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[7, -100, 3, 5, MyInteger(9), -17];
    x->printed
};
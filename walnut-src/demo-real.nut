module demo-real:

MyReal := Real<4..12>;
MyReal->flip(=> MyReal) :: MyReal!{16 - $$};

MyOwnReal := Real<0..100>;
MyUnrelated := #[x: Real]; MyUnrelated ==> Real :: $x;
MyError := ();

/* string specific Real->... */
binaryPlus             = ^[Real<4..12>, Real<-5..7>]       => Real<-1..19>             :: #0 + #1;
binaryMinus            = ^[Real<4..12>, Real<-5..7>]       => Real<-3..17>             :: #0 - #1;
binaryMultiply         = ^[Real<4..12>, Real<-5..7>]       => Real                     :: #0 * #1;
binaryDivide           = ^[Real<4..12>, Real<-5..7>]       => Result<Real, NotANumber> :: #0 / #1;
binaryModulo           = ^[Real<4..12>, Real<-5..7>]       => Result<Real, NotANumber> :: #0 % #1;
binaryPower            = ^[Real<4..12>, Real<-5..7>]       => Real                     :: {#0} ** {#1};
roundAsInteger         = ^Real<1.6..15.4>                  => Integer<2..15>           :: #->roundAsInteger;
roundAsDecimal         = ^[Real<1.6..15.4>, Integer<0..5>] => Real<1..16>              :: #0->roundAsDecimal(#1);
floor                  = ^Real<1.6..15.4>                  => Integer<1..15>           :: #->floor;
ceil                   = ^Real<1.6..15.4>                  => Integer<2..16>           :: #->ceil;
abs                    = ^Real<-120..70>                   => Real<0..120>             :: #->abs;
unaryPlus              = ^Real<-3..8>                      => Real<-3..8>              :: +#;
unaryMinus             = ^Real<-3..8>                      => Real<-8..3>              :: -#;

binaryGreaterThan      = ^[Real<4..12>, Real<-5..9>]       => Boolean                  :: #0 > #1;
binaryGreaterThanEqual = ^[Real<4..12>, Real<-5..9>]       => Boolean                  :: #0 >= #1;
binaryLessThan         = ^[Real<4..12>, Real<-5..9>]       => Boolean                  :: #0 < #1;
binaryLessThanEqual    = ^[Real<4..12>, Real<-5..9>]       => Boolean                  :: #0 <= #1;
/* common Any->... */
binaryEqual            = ^[Real<2..15>, Real<..10>]        => Boolean                  :: #0 == #1;
binaryNotEqual         = ^[Real<2..15>, Real<..10>]        => Boolean                  :: #0 != #1;
asString               = ^Real<1..15>                      => String                   :: #->asString;
asInteger              = ^Real<1.6..15.4>                  => Integer<1..15>           :: #->asInteger;
asBoolean              = ^Real<-2..15>                     => Boolean                  :: #->asBoolean;
valueType              = ^Real<1..15>                      => Type<Real<1..15>>        :: #->type;
checkIsOfType               = ^[Real<1..15>, Type]              => Boolean                  :: #0->isOfType(#1);
jsonStringify          = ^Real<1..15>                      => String                   :: #->jsonStringify;

shapeFn                = ^[Shape<Real>, Shape<Real>]        => Real                     :: {#0->shape(`Real)} + {#1->shape(`Real)};

test = ^[a: Real<5..10.7>, b: Real<..5>, c: Real[3.14, 8], d: Real<5..6>, e: MyReal, f: Real<-20..20>] => Result<Map, MyError> :: [
    binaryPlus: binaryPlus[#a, #d],
    binaryMinus: binaryMinus[#a, #d],
    binaryMultiply: binaryMultiply[#a, #d],
    binaryDivide: binaryDivide[#a, #d],
    binaryDivideZero: binaryDivide[#a, 0],
    binaryModulo: binaryModulo[#a, #d],
    binaryModuloZero: binaryModulo[#a, 0],
    binaryPower: binaryPower[#a, #d],
    binaryGreaterThanTrue: binaryGreaterThan[#a, #d],
    binaryGreaterThanSame: binaryGreaterThan[#a, 7.1],
    binaryGreaterThanFalse: binaryGreaterThan[4.3, 6.9],
    binaryGreaterThanEqualTrue: binaryGreaterThanEqual[#a, #d],
    binaryGreaterThanEqualSame: binaryGreaterThanEqual[#a, 7.1],
    binaryGreaterThanEqualFalse: binaryGreaterThanEqual[4.3, 6.9],
    binaryLessThanTrue: binaryLessThan[#a, #d],
    binaryLessThanSame: binaryLessThan[#a, 7.1],
    binaryLessThanFalse: binaryLessThan[4.3, 6.9],
    binaryLessThanEqualTrue: binaryLessThanEqual[#a, #d],
    binaryLessThanEqualSame: binaryLessThanEqual[#a, 7.1],
    binaryLessThanEqualFalse: binaryLessThanEqual[4.3, 6.9],
    roundAsInteger: roundAsInteger(#e->value),
    roundAsDecimal: roundAsDecimal[#e->value, 2],
    unaryPlus: unaryPlus(#c),
    unaryMinus: unaryMinus(#c),
    floor: floor(#e->value),
    ceil: ceil(#e->value),
    absPlus: abs(#e->value),
    absMinus: abs(#f),
    asString: asString(#a),
    asInteger: asInteger(#e->value),
    asBooleanTrue: asBoolean(#a),
    asBooleanFalse: asBoolean(0.0),
    type: valueType(#a),
    isOfTypeTrue: checkIsOfType[#a, type{Real}],
    isOfTypeTrueInteger: checkIsOfType[#a, type{Integer}],
    isOfTypeFalse: checkIsOfType[#a, type{String}],
    binaryEqualTrue: binaryEqual[#d, 5.5],
    binaryEqualFalse: binaryEqual[#a, #b],
    binaryNotEqualTrue: binaryNotEqual[#a, #b],
    binaryNotEqualFalse: binaryNotEqual[#d, 5.5],
    jsonStringify: jsonStringify(#c),
    myReal: #e,
    myRealFlip: #e->flip,
    shapeFn1: shapeFn[MyReal!4.1, MyOwnReal!9.2],
    shapeFn2: shapeFn[42, MyUnrelated[x: 9.2]],
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[7.1, -100, 3.14, 5.5, MyReal!8.939, -17.6];
    x->printed
};
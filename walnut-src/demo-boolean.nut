module demo-boolean:

MyBoolean := #Boolean;

/* specific Boolean->... */
unaryNot            = ^Boolean            => Boolean                 :: !#;
binaryAnd           = ^[Boolean, Boolean] => Boolean                 :: #0 && #1;
binaryOr            = ^[Boolean, Boolean] => Boolean                 :: #0 || #1;
binaryXor           = ^[Boolean, Boolean] => Boolean                 :: #0 ^^ #1;

/* common Any->... */
binaryEqual         = ^[Boolean, Boolean] => Boolean                 :: #0 == #1;
binaryNotEqual      = ^[Boolean, Boolean] => Boolean                 :: #0 != #1;
asString            = ^Boolean            => String['true', 'false'] :: #->asString;
asInteger           = ^Boolean            => Integer<0..1>  :: #->asInteger;
asReal              = ^Boolean            => Real[0.0, 1.0] :: #->asReal;
valueType           = ^Boolean            => Type<Boolean>  :: #->type;
checkIsOfType            = ^[Boolean, Type]    => Boolean        :: #0->isOfType(#1);
jsonStringify       = ^Boolean            => String         :: #->jsonStringify;

test = ^[a: Boolean, b: Boolean, c: True, d: False, e: MyBoolean] => Map :: [
    unaryNot: unaryNot(#c),
    binaryAnd: binaryAnd[#d, #a],
    binaryOr: binaryOr[#d, #a],
    binaryXor: binaryXor[#d, #e->value],
    asString: asString(#a),
    asReal: asReal(#a),
    asInteger: asInteger(#b),
    type: valueType(#a),
    isOfTypeTrue: checkIsOfType[#a, type{Boolean}],
    isOfTypeFalse: checkIsOfType[#a, type{String}],
    binaryEqualTrue: binaryEqual[#a, #c],
    binaryEqualFalse: binaryEqual[#a, #b],
    binaryNotEqualTrue: binaryNotEqual[#a, #b],
    binaryNotEqualFalse: binaryNotEqual[#a, #c],
    jsonStringify: jsonStringify(#c),
    myBoolean: #e,
    end: 'end'
];

main = ^Array<String> => String :: {
    x = test[true, false, true, false, MyBoolean(true)];
    x->printed
};
module cast888:

MyAtom = :[];
Suit = :[Hearts, Diamonds, Clubs, Spades];

onlyFirstValueOfEnumType = ^Type<Enumeration> => Result<Type<EnumerationSubset>, UnknownEnumerationValue> ::
    #->withValues[{#->values}.0];

q = ^[i: IntegerRange, r: RealRange, l: LengthRange, t: Type<Boolean>,
    iv: Array<Integer, 2..5>, rv: Array<Real, 1..>, sv: Array<String, 3..4>,
    ev: Array<Suit, 1..3>
] => [
    Type<Integer>,
    Type<Real>,
    Type<String>,
    Type<Array<Boolean>>,
    Type<Map<Boolean>>,
    Type<Array<Boolean, 1..5>>,
    Type<Map<Boolean, 1..5>>,
    Type<Result<Integer, Boolean>>,
    Type<Result<Boolean, String>>,
    Type<^Integer => Boolean>,
    Type<^Nothing => String>,
    Type<IntegerSubset>,
    Type<RealSubset>,
    Type<StringSubset>,
    Type<Suit>,
    Result<Type<EnumerationSubset>, UnknownEnumerationValue>,
    Type<Tuple>,
    Type<Record>,
    Type<Tuple>,
    Type<Record>,
    Type<Type<Boolean>>,
    Type<MutableType>,
    Result<MutableType, CastNotAvailable>,
    Result<MutableType, CastNotAvailable>,
    Mutable<Integer>
] :: [
    type{Integer}->withRange(#i),
    type{Real}->withRange(#r),
    type{String}->withLengthRange(#l),
    type{Array<Boolean>}->withLengthRange(#l),
    type{Map<Boolean>}->withLengthRange(#l),
    type{Array<String, 1..5>}->withItemType(#t),
    type{Map<String, 1..5>}->withItemType(#t),
    type{Result<Integer, String>}->withErrorType(#t),
    type{Result<Integer, String>}->withReturnType(#t),
    type{^Integer => String}->withReturnType(#t),
    type{^Integer => String}->withParameterType(#t),
    type{Integer}->withValues(#iv),
    type{Real}->withValues(#rv),
    type{String}->withValues(#sv),
    type{Suit}->withValues(#ev),
    onlyFirstValueOfEnumType(type{Suit}),
    type[Integer, Real, ... String]->withRestType(#t),
    type[a: Integer, b: Real, ... String]->withRestType(#t),
    type[Integer, Real, ... String]->withItemTypes[#t],
    type[a: Integer, b: Real, ... String]->withItemTypes[a: #t],
    type{Type}->withRefType(#t),
    type{Mutable}->withValueType(#t),
    1->asMutableOfType(#t),
    true->asMutableOfType(#t),
    mutable{Integer, -42}
];

/* Exec exc */

myFn = ^Any :: {
    q[
        ?noError(IntegerRange[1, 10]),
        ?noError(RealRange[MinusInfinity[], 3.14]),
        ?noError(LengthRange[7, PlusInfinity[]]),
        type{True},
        [0, 2, -5],
        [-3.14],
        ['', 'hello', 'world', '!'],
        [Suit.Hearts, Suit.Diamonds, Suit.Clubs]
    ]
};

main = ^Array => String :: myFn()->printed;
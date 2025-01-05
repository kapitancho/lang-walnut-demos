module cast801:

IsLocal = Boolean;
==> IsLocal :: true;

/* Sealed types are built on top of records and they don't expose their internal value */
SealedWithoutConstructor = $[a: Integer, b: String];

SealedWithConstructor = $[c: Real, d: Boolean];
/* By adding a constructor, the initialization can differ from the internal value */
SealedWithConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

SealedWithDependency = $[e: Real, f: Boolean];
SealedWithDependency[e: Real] %% [~IsLocal] :: [e: #e, f: %isLocal];

SealedWithError = $[g: Real, h: Boolean];
SealedWithError[g: Real] @ String :: ?whenValueOf(#g) is { 0 : => @'Error: 0 is not allowed', ~: [g: #g, h: true]};

/* Subtypes can be built on top of any type and their internal value is exposed */
SubtypeWithoutConstructor <: [a: Integer, b: String];

SubtypeWithValidator <: [a: Integer, b: String] @ Any :: ?whenValueOf(#a) is { 0 : => @'Error: 0 is not allowed', ~: null};

SubtypeWithConstructor <: [c: Real, d: Boolean];
/* By adding a constructor, a data validation can happen */
SubtypeWithConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

SubtypeWithValidatorAndConstructor <: [c: Real, d: Boolean] @ Any :: ?whenValueOf(#c) is { 0 : => @'Error: 0 is not allowed', ~: null};
SubtypeWithValidatorAndConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

SubtypeWithDependency <: [e: Real, f: Boolean];
SubtypeWithDependency[e: Real] %% [~IsLocal] :: [e: #e, f: %isLocal];

SubtypeWithError <: [g: Real, h: Boolean];
SubtypeWithError[g: Real] @ String :: ?whenValueOf(#g) is { 0 : => @'Error: 0 is not allowed', ~: [g: #g, h: true]};

SubtypeScalarWithoutConstructor <: Integer<0..>;
SubtypeScalarWithConstructor <: Integer<0..>;
SubtypeScalarWithConstructor[v: Real] :: {#v->abs}->asInteger;

SubtypeScalarWithDependency <: Integer;
SubtypeScalarWithDependency[v: Integer] %% [~IsLocal] :: ?whenIsTrue { %isLocal: #v, ~: 0 - #v };

SubtypeScalarWithError <: Integer<1..>;
SubtypeScalarWithError[v: String] @ String :: ?whenTypeOf(#v) is { type{String<1..>}: #v->length, ~: @'Error: \`\` is not allowed'};

myFn = ^Any => Any :: {
    /* This is the normal way to create an instance of a sealed class */
    s1 = SealedWithoutConstructor[a: 1, b: 'Hello'];
    /* This is also allowed - the arguments can be passed as a tuple */
    s2 = SealedWithoutConstructor[2, 'World'];

    /* The instance is constructed according to the constructor parameter type */
    s3 = SealedWithConstructor[c: 3.14];
    /* Once again a tuple is accepted in the place of a record */
    s4 = SealedWithConstructor[-2.71];

    s5 = SealedWithDependency[e: 2.71];
    s6 = SealedWithDependency[3.14];

    s7 = SealedWithError[g: 2.71];
    s8 = SealedWithError[0];

    /* This is the normal way to create an instance of a subtype value */
    u1 = SubtypeWithoutConstructor[a: 1, b: 'Hello'];
    /* This is also allowed - the arguments can be passed as a tuple */
    u2 = SubtypeWithoutConstructor[2, 'World'];

    /* The instance is constructed according to the constructor parameter type */
    u3 = SubtypeWithConstructor[c: 3.14];
    /* Once again a tuple is accepted in the place of a record */
    u4 = SubtypeWithConstructor[-2.71];

    u5 = SubtypeWithDependency[e: 2.71];
    u6 = SubtypeWithDependency[3.14];

    u7 = SubtypeWithError[g: 2.71];
    u8 = SubtypeWithError[0];

    v1 = SubtypeScalarWithoutConstructor(7);
    v2 = SubtypeScalarWithConstructor[-12];
    v3 = SubtypeScalarWithDependency[3];
    v4 = SubtypeScalarWithError[''];
    v5 = SubtypeScalarWithError['Hello'];

    n1 = SubtypeWithValidator[0, 'Hello'];
    n2 = SubtypeWithValidator[1, 'Hello'];
    n3 = SubtypeWithValidatorAndConstructor[0];
    n4 = SubtypeWithValidatorAndConstructor[7];
    n5 = SubtypeWithValidatorAndConstructor[-12];

    [
        s1, s2, s3, s4, s5, s6, s7, s8,
        u1, u2, u3, u4, u5, u6, u7, u8,
        v1, v2, v3, v4, v5,
        n1, n2, n3, n4, n5
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
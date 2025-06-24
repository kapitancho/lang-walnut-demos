module cast801:

IsLocal = Boolean;
==> IsLocal :: true;

/* Sealed types are built on top of records and they don't expose their internal value */
SealedWithoutConstructor := $[a: Integer, b: String];

SealedWithConstructor := $[c: Real, d: Boolean];
/* By adding a constructor, the initialization can differ from the internal value */
SealedWithConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

SealedWithDependency := $[e: Real, f: Boolean];
SealedWithDependency[e: Real] %% [~IsLocal] :: [e: #e, f: %isLocal];

SealedWithError := $[g: Real, h: Boolean];
SealedWithError[g: Real] @ String :: ?whenValueOf(#g) is { 0 : => @'Error: 0 is not allowed', ~: [g: #g, h: true]};

/* Subtypes can be built on top of any type and their internal value is exposed */
OpenWithoutConstructor := #[a: Integer, b: String];

OpenWithValidator := #[a: Integer, b: String] @ Any :: ?whenValueOf(#a) is { 0 : => @'Error: 0 is not allowed', ~: null};

OpenWithConstructor := #[c: Real, d: Boolean];
/* By adding a constructor, a data validation can happen */
OpenWithConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

OpenWithValidatorAndConstructor := #[c: Real, d: Boolean] @ Any :: ?whenValueOf(#c) is { 0 : => @'Error: 0 is not allowed', ~: null};
OpenWithValidatorAndConstructor[c: Real] :: [c: #c, d: ?whenTypeOf(#c) is { type{Real<0..>} : true, ~ : false}];

OpenWithDependency := #[e: Real, f: Boolean];
OpenWithDependency[e: Real] %% [~IsLocal] :: [e: #e, f: %isLocal];

OpenWithError := #[g: Real, h: Boolean];
OpenWithError[g: Real] @ String :: ?whenValueOf(#g) is { 0 : => @'Error: 0 is not allowed', ~: [g: #g, h: true]};

OpenScalarWithoutConstructor := #Integer<0..>;
OpenScalarWithConstructor := #Integer<0..>;
OpenScalarWithConstructor[v: Real] :: {#v->abs}->asInteger;

OpenScalarWithDependency := #Integer;
OpenScalarWithDependency[v: Integer] %% [~IsLocal] :: ?whenIsTrue { %isLocal: #v, ~: 0 - #v };

OpenScalarWithError := #Integer<1..>;
OpenScalarWithError[v: String] @ String :: ?whenTypeOf(#v) is { type{String<1..>}: #v->length, ~: @'Error: \`\` is not allowed'};

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

    /* This is the normal way to create an instance of a Open value */
    u1 = OpenWithoutConstructor[a: 1, b: 'Hello'];
    /* This is also allowed - the arguments can be passed as a tuple */
    u2 = OpenWithoutConstructor[2, 'World'];

    /* The instance is constructed according to the constructor parameter type */
    u3 = OpenWithConstructor[c: 3.14];
    /* Once again a tuple is accepted in the place of a record */
    u4 = OpenWithConstructor[-2.71];

    u5 = OpenWithDependency[e: 2.71];
    u6 = OpenWithDependency[3.14];

    u7 = OpenWithError[g: 2.71];
    u8 = OpenWithError[0];

    v1 = OpenScalarWithoutConstructor(7);
    v2 = OpenScalarWithConstructor[-12];
    v3 = OpenScalarWithDependency[3];
    v4 = OpenScalarWithError[''];
    v5 = OpenScalarWithError['Hello'];

    n1 = OpenWithValidator[0, 'Hello'];
    n2 = OpenWithValidator[1, 'Hello'];
    n3 = OpenWithValidatorAndConstructor[0];
    n4 = OpenWithValidatorAndConstructor[7];
    n5 = OpenWithValidatorAndConstructor[-12];

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
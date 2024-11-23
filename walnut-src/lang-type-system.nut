module lang-type-system:

/* there are three main ways to define a type - as an alias, as a subtype, and as a state type */
/* 1. alias */
PointA = [x: Real, y: Real];
/* 2. subtype */
PointB <: [x: Real, y: Real];
/* 3. state */
PointC = $[x: Real, y: Real];

/* instantiating data */
newPointA = ^Null => PointA :: [x: 3.14, y: -2]; /* it is enough to hava e matching structure (type) */
newPointB = ^Null => PointB :: PointB[x: 3.14, y: -2]; /* explicitly set to PointB */
newPointC = ^Null => PointC :: PointC[x: 3.14, y: -2]; /* explicitly set to PointC */

/* the functions can have just one parameter (#) so in order to pass multiple parameters
one should use Records and Tuples. Point[...] is a shorthand of PointB([...]). */

/* accessing data */
accessPointA = ^PointA => Real :: #.x;
accessPointB = ^PointB => Real :: #.x;
/* not allowed because state properties are not accessible */
/* accessPointC = ^PointC => Real :: #.x; */

/* adding behavior */
PointA->moveHorizontally(^Real => PointA) :: [x: $.x + #, y: $.y];
PointB->moveHorizontally(^Real => PointB) :: PointB[x: $.x + #, y: $.y];
PointC->moveHorizontally(^Real => PointC) :: PointC[x: $.x + #, y: $.y];

/* cast to another type, $ is similar to 'this' in other languages */
PointB ==> String :: ['(', $.x->asString, ', ', $.y->asString, ')']->combineAsString('');
PointA ==> String :: ['(', $.x->asString, ', ', $.y->asString, ')']->combineAsString('');
PointC ==> String :: ['(', $.x->asString, ', ', $.y->asString, ')']->combineAsString('');

/* subtype specialty 1 - subtyping basic types like Integer, Real, Boolean, String, etc. */
UuidString <: String<36..36>;
/* subtype specialty 2 - "Value Object"-like behavior */
MyRange <: [min: Integer, max: Integer] @ String :: ?whenIsTrue { #.min > #.max : Error('Invalid Range'), ~: null };

/* state type constructor */
MyStateType = $[x: Integer, y: Integer];
MyStateType([x: Real, y: Real]) :: [x: #.x->asInteger, y: #.y->asInteger];

/* all examples in one place */
main = ^Array<String> => String :: [
    pointAx: accessPointA(newPointA(null)->moveHorizontally(1)),
    pointB: accessPointB(newPointB(null)->moveHorizontally(1.5)),
    pointC: newPointC(null)->moveHorizontally(2)->asString,
    validRange: MyRange[min: 1, max: 10],
    invalidRange: MyRange[min: 10, max: 1],
    uuid: UuidString('123e4567-e89b-12d3-a456-426614174000'),
    myState: MyStateType[x: 3.14, y: -2]
]->printed;

/*
Result: [
    pointAx: 4.14,
    pointB: 4.64,
    pointC: (5.14, -2),
    validRange: MyRange[min: 1, max: 10],
    invalidRange: @'Invalid Range',
    uuid: UuidString{'123e4567-e89b-12d3-a456-426614174000'},
    myState: MyStateType[x: 3, y: -2]
]
*/
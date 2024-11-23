module demo-state:

/* This is our sample type with an internal value 'a' */
T = $[a: Integer];
/* A value of that type is created by passing 'b' and 'c' */
T[b: Integer, c: Integer] :: [a: #.b + #.c];

StateTest = :[];
StateTest->run(^Any => Any) :: [
    /* This is how a value of that type is normally created */
    T[b: 1, c: 2],

    /* How shall we reconstruct a value that has been
       previously persisted in a DB/file/elsewhere? */

    /* Option 1: a value is created by preparing the 'constructor' arguments */
    [b: 1, c: 2]->asJsonValue->hydrateAs(type{T}),

    /* Option 2: a value is created by preparing the type internal value */
    [a: 5]->asJsonValue->hydrateAs(type{T})
];

main = ^Any => String :: StateTest[]->run->printed;

module lang-update3:

CannotGetSeven = :[];

getSeven = ^Array<Integer> => Result<Integer, CannotGetSeven> :: {
    x = #->item(7);
    ?whenTypeOf(x) is {
        /*error{IndexOutOfRange}: Error(CannotGetSeven[]),*/
        type{Error<IndexOutOfRange>}: Error(CannotGetSeven[]),
        type{Integer}: x
    }
};

rf1 = ^Integer => Integer :: #;
rf2 = ^Integer => Result<Integer, String> :: #;
rf3 = ^[num: Integer] => Integer :: #.num;

Sub1 <: Integer;
Sub2 <: Integer @ String :: null;

Integer->mt1(^[input: Integer] => Integer) :: $ + #.input;
Integer->mt2(^Integer => Result<Integer, String>) :: $ + #;

St0 = $[num: Integer];
St1 = $[num: Integer];
St2 = $[num: Integer];
St2[input: Integer] :: [num: #.input];
St3 = $[num: Integer];
St3[input: Integer] @ String :: [num: #.input];
St4 = $[num: Integer];
Constructor->St4(^[input: Integer] => Result<[num: Integer], String>) :: [num: #.input];
St5 = $[num: Integer];
St5[input: Integer] %% [~Sub1] :: [num: #.input + %.sub1];

St1 ==> Integer :: $.num;
St2 ==> Integer @ String :: $.num;
St4 ==> Integer :: $.num;
St5 ==> Integer :: $.num;

St7 = $[~St0];

==> St0 :: St0[3];
==> St2 :: St2[3];

Sub2->dep8(^Null => Integer) %% [~St7] :: $;

St3->dep7(^Null => Integer) %% [~St7] :: $.num;
St3->dep5(^Null => Integer) %% [~St0] :: $.num;
/*St3->dep1(^Null => Integer) %% [~St1] :: $.num;*/
St3->dep2(^Null => Integer) %% [~St2] :: $.num;
St3->dep3(^Null => Integer) %% [~Sub1] :: $.num + %.sub1; /* TODO: 4/6 the error type of ==> Sub1 should not be ignored */
/*==> Sub1 @ String :: Error('oops');*/
==> Sub1 :: Sub1(3);
St3->dep4(^Null => Result<Integer, String>) %% [~Sub1] :: $.num + ?noError(%.sub1->asReal)->asInteger;
Sub1 ==> Real @ String :: 3.14;

myFn = ^Null => Result<Array<Integer|St1|St2|St3>, String> :: {
    [
        rf1(3),
        ?noError(rf2(3)),
        rf3[3],
        Sub1(3),
        ?noError(Sub2(3)),
        42->mt1[3],
        ?noError(42->mt2(3)),
        {St1[3]}->asInteger,
        ?noError({St2[3]}->asInteger),
        ?noError(St3[3])->dep3,
        ?noError(?noError({St3[3]})->dep4),
        ?noError(St4[3])->asInteger,
        {St5[3]}->asInteger
    ]
};

main = ^Array<String> => String :: {
    [
        getSeven[1, 5, 10],
        getSeven(5->downTo(-10)),
        myFn(),

        type{Result<Integer, IndexOutOfRange>}->isSubtypeOf(type{Error<IndexOutOfRange>|Integer}),
        type{Error<IndexOutOfRange>|Integer}->isSubtypeOf(type{Result<Integer, IndexOutOfRange>})
    ]->printed
};
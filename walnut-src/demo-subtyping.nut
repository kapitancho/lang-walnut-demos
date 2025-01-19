module demo-subtyping:

NotAnEvenInteger = :[];
EvenInteger <: Integer @ NotAnEvenInteger ::
    /* Guard clause */
    ?when({# % 2} == 1) { => @NotAnEvenInteger[] };

/* Extra behavior */
EvenInteger->half(=> Integer) :: $ // 2;

/* Example function */
isTwelve = ^Integer => Boolean :: # == 12;

fn = ^Any => Any :: {
    i = 12;
    myEven = ?noError(EvenInteger(12));
    [
        isSameInteger: i == myEven,

        isTwelveI: isTwelve(i),
        isTwelveMyEven: isTwelve(myEven),

        halfI: 'n/a', /* Doesn't work: i->half, */
        halfMyEven: myEven->half,

        oddInteger: EvenInteger(13)
    ];
};

main = ^Any => String :: fn()->printed;
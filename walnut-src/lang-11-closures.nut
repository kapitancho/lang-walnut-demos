module lang-11-closures:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/11_closures/main.go */

adder = ^Null => ^Integer => Integer :: {
    sum = Mutable[type{Integer}, 0];
    ^Integer => Integer :: {
        sum->SET({sum->value} + #);
        sum->value
    }
};

main = ^Any => String :: {
    sum = adder();
    0->upTo(9)->map(sum)->printed
};
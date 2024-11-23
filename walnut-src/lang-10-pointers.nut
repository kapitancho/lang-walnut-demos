module lang-10-pointers:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/10_pointers/main.go */

main = ^Any => String :: {
    a = Mutable[type{Integer}, 5];
    b = a;

    a->DUMPNL;
    b->DUMPNL;

    b->value->DUMPNL;

    b->SET(10);

    a->printed
};
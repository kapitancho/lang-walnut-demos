module lang-07-loops:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/07_loops/main.go */

main = ^Any => String :: [
    1->upTo(10)->map(^n: Integer => String :: n->asString),
    1->upTo(10)->map(^n: Integer => String :: 'Number ' + n->asString),
    1->upTo(100)->map(^n: Integer => String :: ?whenIsTrue {
        {n % 15} == 0: 'FizzBuzz',
        {n % 3} == 0: 'Fizz',
        {n % 5} == 0: 'Buzz',
        ~: n->asString
    })
]->printed;
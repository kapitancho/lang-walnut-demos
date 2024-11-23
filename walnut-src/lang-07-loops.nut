module lang-07-loops:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/07_loops/main.go */

main = ^Any => String :: [
    1->upTo(10)->map(^Integer => String :: #->asString),
    1->upTo(10)->map(^Integer => String :: 'Number '->concat(#->asString)),
    1->upTo(100)->map(^Integer => String :: ?whenIsTrue {
        {# % 15} == 0: 'FizzBuzz',
        {# % 3} == 0: 'Fizz',
        {# % 5} == 0: 'Buzz',
        ~: #->asString
    })
]->printed;
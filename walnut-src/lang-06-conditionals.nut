module lang-06-conditionals:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/06_conditionals/main.go */

main = ^Any => String :: {
    x = 15;
    y = 10;

    color = 'blue';
    [
        ?whenIsTrue {
            x < y: [x->asString, ' is less than ', y->asString],
            y < x: [y->asString, ' is less than ', x->asString],
            ~ : ''
        },
        ?whenValueOf(color) is {
            'red': 'color is red',
            ~: 'It``s a different color than red'
        },
        ?whenValueOf(color) is {
            'red': 'The color is red',
            'blue': 'The color is blue',
            ~: 'It``s a different color than red or blue'
        }
    ]->printed
};
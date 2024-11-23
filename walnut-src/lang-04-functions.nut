module lang-04-functions:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/04_functions/main.go */

greeting = ^String => String :: 'Hello'->concat(#);

getSum = ^[num1: Integer, num2: Integer] => Integer :: #.num1 + #.num2;

main = ^Any => String :: [greeting('Gabriel'), getSum[2, 6]]->printed;
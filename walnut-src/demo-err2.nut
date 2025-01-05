module demo-err2:

/* Test for analyser exception */
x = ^Integer => String :: #;

main = ^Any => String :: x(1);
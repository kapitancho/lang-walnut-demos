module demo-err2:

/* Test for analyser exception */
xyz = ^Integer => String :: #;

main = ^Any => String :: xyz(1);
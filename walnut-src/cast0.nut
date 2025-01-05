module cast0:

check = ^Any => Integer|Null :: ?when(#) { 1 };

main = ^Any => String :: check(0)->printed;
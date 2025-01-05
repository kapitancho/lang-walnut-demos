module demo-err9:

/* Test for invalid type name */

main = ^Any => String :: mutable{MyType, 1}->printed;
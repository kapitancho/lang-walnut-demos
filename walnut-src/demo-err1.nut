module demo-err1:

/* Test for invalid range */
MyInt = Integer<50..15>;
MyReal = Real<3.14..-2>;
MyString = String<5..3>;

main = ^Any => String :: 'Hello World!';
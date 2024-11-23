module lang-02-variables:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/02_variables/main.go */

main = ^Any => String :: {
    myAge = 21;
    isCool = true;
    name = 'Gabriel'; email = 'test@test.com';
    size = 1.3;

    [name, myAge, isCool, size, email]->printed
    /* String->format is not yet implemented */
};
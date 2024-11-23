module lang-03-packages %% lang-03-packages-reverse:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/03_packages/main.go */

main = ^Any => String :: [
    3.4->floor,
    5.7->ceil,
    64->sqrt,
    'Hello backwards.'->reverse
]->printed;
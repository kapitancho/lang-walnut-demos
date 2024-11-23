module cast208 %% cast208_domain, cast208_db:

X = :[];
X->temp(^ProductId => Result<Product, UnknownProduct>) %% ProductById :: %(#);

myFn = ^Array<String> => Any :: {
    X[]->temp(14)
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
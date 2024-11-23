module demo-password:

UserTest = ^Null => Any;
==> UserTest :: ^Null => Any :: {
    pass1 = PasswordString['test-123'];
    pass2 = PasswordString['test-456'];
    hash = pass1->hash;
    [
        pass1->verify(hash),
        pass2->verify(hash),
        hash
    ]
};

main = ^Array<String> => String %% [~UserTest] :: %userTest()->printed;

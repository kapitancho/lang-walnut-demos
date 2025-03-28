module lang-update5:

MyType = #Integer;

/*==> MyType @ String :: Error('oops');*/
==> MyType @ String :: MyType(12);

MyNestedType = $[~MyType];
==> MyNestedType %% MyType :: MyNestedType[%];

MyTarget = #Integer;

MyTarget->special(=> Integer) %% [nested: MyType] :: $$ + %.nested->value;
MyTarget->another(=> Integer) %% [~MyNestedType] :: $$ + {%.myNestedType}->type->printed->length;

testMyTarget = ^Null => Integer :: MyTarget(10)->another;

main = ^Array<String> => String :: [
    testMyTarget()
]->printed;
module lang-update5:

MyType <: Integer;

==> MyType @ String :: Error('oops');
/*==> MyType @ String :: MyType(12);*/

MyNestedType = $[~MyType];
==> MyNestedType %% MyType :: MyNestedType[%];

MyTarget <: Integer;

MyTarget->special(^Null => Integer) %% [nested: MyType] :: $ + %.nested;
MyTarget->another(^Null => Integer) %% [~MyNestedType] :: $ + {%.myNestedType}->type->printed->length;

testMyTarget = ^Null => Integer :: MyTarget(10)->another;

main = ^Array<String> => String :: [
    testMyTarget()
]->printed;
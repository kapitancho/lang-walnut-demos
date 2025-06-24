module multicall:

Value = Mutable<Integer>;

==> Value :: mutable{Integer, 0};

fn = ^Array<String> => Any %% Value :: {
    %->SET(%->value + # => item(0) => asInteger)
};

main = ^Array<String> => String :: fn(#)->printed;
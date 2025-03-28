module demo-tpl-inc %% $tpl, demo-tpl-model:

ProductList ==> Template :: {
    output = Template(mutable{String, ''});

    output->value->APPEND('<h1>Product List</h1>');
    output->value->APPEND('<ul>');
    $products->map(^Product => Any :: {
        output->value->APPEND('<li>');
        output->value->APPEND(#name);
        output->value->APPEND(': $');
        output->value->APPEND(#price->roundAsDecimal(2)->asString);
        output->value->APPEND('</li>')
    });
    output->value->APPEND('</ul>');

    output
};
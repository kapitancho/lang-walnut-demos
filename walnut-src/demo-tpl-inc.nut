module demo-tpl-inc %% tpl, demo-tpl-model:

ProductList ==> Template :: {
    output = Template(mutable{String, ''});

    output->APPEND('<h1>Product List</h1>');
    output->APPEND('<ul>');
    $products->map(^Product => Any :: {
        output->APPEND('<li>');
        output->APPEND(#name);
        output->APPEND(': $');
        output->APPEND(#price->roundAsDecimal(2)->asString);
        output->APPEND('</li>')
    });
    output->APPEND('</ul>');

    output
};
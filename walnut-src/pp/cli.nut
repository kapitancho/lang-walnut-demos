module pp/cli %% pp/model:

CliCommands := ();
CliCommands->showHelp(=> String) :: 'Usage: php -f cli/index.php pp/main [command] [options]';
CliCommands->productById(^productIdString: String => String) %% [~ProductById] :: {
    productId = productIdString->asInteger;
    ?whenTypeOf(productId) is {
        type{Integer<1..>}: {
            result = %productById(ProductId(productId));
            ?whenTypeOf(result) is {
                type{Error<UnknownProductId>}: 'Unknown Product Id: ' + {productId->asString},
                type{Product}: result.name->value,
                type{Error<ExternalError>}: 'Error: ' + result->printed
            }
        },
        ~: 'Invalid Product Id: ' + productIdString
    }
};
CliCommands->listProducts(=> String) %% [~ProductList] :: {
    result = %productList();
    ?whenIsError(result) {
        'Error: ' + result->printed
    } ~ {
        {result->map(^ ~Product => String :: product.name->value)}->combineAsString('\n')
    }
};
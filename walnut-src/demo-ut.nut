module demo-ut %% $datetime:

ProductId = Integer<1..>;
ProductTitle = String<1..>;
UnknownProduct = $[~ProductId];
Product = #[id: ProductId, title: ProductTitle];
ProductById = ^ProductId => Result<Product, UnknownProduct|ExternalError>;
MyClock = ^Null => Result<DateAndTime, ExternalError>;

==> MyClock :: ^Null => DateAndTime %% Clock :: %->now;

==> MyClock ::
    ^Null => Result<DateAndTime, ExternalError> :: {
        ?whenIsError(val = '2024-04-04 12:34:56'->asDateAndTime) {
            @ExternalError[errorType: 'generic', originalError: val, errorMessage: 'Something went wrong']
        }
    };

==> ProductById :: ^ProductId => Result<Product, UnknownProduct|ExternalError> :: Product[#, 'My First Product'];

main = ^Any => String %% [~ProductById, ~MyClock] :: [currentTime: %.myClock(), myFirstProduct: %.productById(1)]->printed;
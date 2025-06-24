module demo-money:

Amount = Real;
Currency := (Euro, Dollar, Yen);
Currency->code(^Null => String<3>) :: ?whenValueOf($) is {
    Currency.Euro: 'EUR',
    Currency.Dollar: 'USD',
    Currency.Yen: 'JPY'
};

/* Some convenient conversions to other types */
Currency ==> String :: ?whenValueOf($) is {
    Currency.Euro: '€',
    Currency.Dollar: '$',
    Currency.Yen: '¥'
};
Currency ==> JsonValue :: $->code;
/* Support for JSON to Currency conversion */
InvalidCurrency := (); /* An Atom that represents an invalid currency */
JsonValue ==> Currency @ InvalidCurrency :: ?whenValueOf($) is {
    'EUR': Currency.Euro,
    'USD': Currency.Dollar,
    'JPY': Currency.Yen,
    ~: @InvalidCurrency
};

/* Money is a record with two fields: currency and amount */
Money := #[~Currency, ~Amount];
Money ==> String :: {$currency->asString} + $amount->asString;

/*
 * The result is impure (*Real = Impure<Real> = Result<Real, ExternalError>)
 * because it depends on the external exchange rate provider
 */
ExchangeRateProvider = ^[fromCurrency: Currency, toCurrency: Currency] => *Real;
MoneyCurrencyConvertor = ^[money: Money, toCurrency: Currency] => *Money;

/* Implementation of the MoneyCurrencyConvertor function "interface" */
==> MoneyCurrencyConvertor %% [~ExchangeRateProvider] :: ^[money: Money, toCurrency: Currency] => *Money :: {
    rate = %exchangeRateProvider => invoke [#money.currency, #toCurrency];
    amount = #money.amount * rate;
    Money[#toCurrency, amount]
};

/* Mock exchange rate provider implementation */
==> ExchangeRateProvider :: ^[fromCurrency: Currency, toCurrency: Currency] => *Real :: ?whenValueOf(#fromCurrency) is {
    Currency.Euro: ?whenValueOf(#toCurrency) is {
        Currency.Euro: 1,
        Currency.Dollar: 1.2,
        Currency.Yen: 130.0
    },
    Currency.Dollar: ?whenValueOf(#toCurrency) is {
        Currency.Euro: 0.8,
        Currency.Dollar: 1,
        Currency.Yen: 105.0
    },
    Currency.Yen: ?whenValueOf(#toCurrency) is {
        Currency.Euro: 0.0077,
        Currency.Dollar: 0.0095,
        Currency.Yen: 1
    }
};

/* Adding support for money + money and money - money */
Money->binaryPlus(^Money => *Money) %% [~MoneyCurrencyConvertor] :: {
    m = %moneyCurrencyConvertor => invoke [#, $currency];
    Money[$currency, $amount + m.amount]
};
Money->binaryMinus(^Money => *Money) %% [~MoneyCurrencyConvertor] :: {
    m = %moneyCurrencyConvertor => invoke [#, $currency];
    Money[$currency, $amount - m.amount]
};
/* Adding support for money * multiplier */
Money->binaryMultiply(^Real => Money) :: Money[$currency, $amount * #];

/* Transform to a different currency */
Money->toCurrency(^Currency => *Money) %% [~MoneyCurrencyConvertor] :: %moneyCurrencyConvertor => invoke [$, #];

amountAnalyser = ^[amount: Amount, ...] => String :: ?whenTypeOf(#amount) is {
    type{Real<0..0>}: 'zero',
    type{Real<0..>}: 'positive',
    ~: 'negative'
};

main = ^Array<String> => String :: {
    myEuro = Money[Currency.Euro, 100];
    myEuroDoubled = myEuro * 2;
    myEuroInYen = myEuro->toCurrency(Currency.Yen);
    myDollar = Money[Currency.Dollar, 70];
    myTotal = myEuro + myDollar;
    myDiff = myEuro - myDollar;
    myImportedMoney = [currency: 'EUR', amount: 3.14]->hydrateAs(type{Money});
    myInvalidCurrency = 'XYZ'->hydrateAs(type{Currency});
    [
        euro: myEuro,
        euroDoubled: myEuroDoubled -> asJsonValue,
        euroInYen: myEuroInYen,
        dollar: myDollar,
        total: myTotal->asString,
        diff: myDiff,
        importedMoney: myImportedMoney,
        invalidCurrency: myInvalidCurrency,
        amountType: amountAnalyser(myEuro->value)
    ]->printed
};
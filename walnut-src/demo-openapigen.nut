module demo-openapigen %% demo-openapi-types, demo-openapi-src:


test = ^Any => Any :: [
    type[
        any: JsonValue,
        null: Null,
        boolean: Boolean,
        integer: Integer,
        rangedInteger: Integer<2..5>,
        real: Real,
        rangedReal: Real<2..5>,
        string: String,
        rangedString: String<2..5>,
        stringSubset: String['hello', 'world'],
        alias: JsonValue,
        union: String|Integer,
        intersection: String&Integer,
        array: Array<String>,
        rangedArray: Array<String, 2..5>,
        map: Map<String>,
        rangedMap: Map<String, 2..5>,
        openRecord: [a: Real, b: String, c: ?Boolean, ... Integer],
        closedRecord: [a: Real, b: String],
        optional: ?JsonValue
    ]->openApiSchema->stringify,
    type{JsonValue}->aliasedType->openApiSchema->stringify
];

main = ^Array<String> => String :: test()->printed;
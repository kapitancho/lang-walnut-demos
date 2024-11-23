module lang-09-range:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/09_range/main.go */

main = ^Any => String :: {
    ids = [12, 42, 33, 43, 53];
    emails = [Bob: 'bob@gmail.com', Mark: 'mark@gmail.com'];
    [
        ids->mapIndexValue(^[index: Integer, value: Integer] => String ::
            [#.index->asString, ' - ID: ', #.value->asString]->combineAsString('')),
        ids->sum,
        emails->mapKeyValue(^[key: String, value: String] => String ::
            [#.key, ': ', #.value]->combineAsString(''))->values,
        emails->keys->map(^String => String :: 'Name: '->concat(#))
    ]->printed
};
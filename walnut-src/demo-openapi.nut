module demo-openapi %% fs, demo-openapi-types, demo-openapi-src:


getOpenAPI = ^Any => Result<OpenAPI> :: {File['../walnut-src/openapi.json']}
    =>content=>jsonDecode=>hydrateAs(type{OpenAPI});

test = ^Any => Result<[String]> :: {
    openAPI = ?noError(getOpenAPI());
    [
        openAPI.info=>item('contact')=>item('name')
    ]
};

main = ^Array<String> => String :: [
    '$ref': test()
]->printed;
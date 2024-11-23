module lang-14-web %% http-core, http-middleware, generic-http:
/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/14_web/main.go */

IndexHandler = :[];
IndexHandler ==> HttpRequestHandler %% [~CreateHttpResponse] :: ^[request: HttpRequest] => Result<HttpResponse, Any> :: {
    %.createHttpResponse(200)->withBody('<h1>Hello world</h1>')
};

AboutHandler = :[];
AboutHandler ==> HttpRequestHandler %% [~CreateHttpResponse] :: ^[request: HttpRequest] => Result<HttpResponse, Any> :: {
    %.createHttpResponse(200)->withBody('<h1>About</h1>')
};

/* The next two should be in a separate file */
==> LookupRouterMapping :: [
    [path: '/about', type: type{AboutHandler}],
    [path: '/', type: type{IndexHandler}]
];

==> CompositeHandler %% [
    defaultHandler: NotFoundHandler,
    ~LookupRouter,
    ~CorsMiddleware
] :: CompositeHandler[
    defaultHandler: %.defaultHandler->as(type{HttpRequestHandler}),
    middlewares: [
        %.corsMiddleware->as(type{HttpMiddleware}),
        %.lookupRouter->as(type{HttpMiddleware})
    ]
];


handleRequest = ^HttpRequest => HttpResponse :: {
    response = HttpServer[]->handleRequest(#);
    ?whenTypeOf(response) is {
        type{HttpResponse}: response,
        ~: [
           statusCode: 500,
           protocolVersion: HttpProtocolVersion.HTTP11,
           headers: [:],
           body: ''
       ]
    }
};

main = ^Any => String :: 'Compilation successful. Please run from an HTTP adapter entry point';
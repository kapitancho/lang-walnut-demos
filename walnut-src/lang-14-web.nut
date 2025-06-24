module lang-14-web %% $http/message, $http/middleware, $http/bundle/composite-router:

/* A Walnut-Lang implementation of https://github.com/gabrieldim/Go-Crash-Course/blob/main/14_web/main.go */

IndexHandler := ();
IndexHandler ==> HttpRequestHandler %% [~HttpResponseBuilder] :: ^request: {HttpRequest} => {HttpResponse} :: {
    %httpResponseBuilder(200)->withBody('<h1>Hello world</h1>' + request->shape(`HttpRequest).target)
};

AboutHandler := ();
AboutHandler ==> HttpRequestHandler %% [~HttpResponseBuilder] :: ^request: {HttpRequest} => {HttpResponse} :: {
    %httpResponseBuilder(200)->withBody('<h1>About</h1>' + request->shape(`HttpRequest).body->asString)
};

/* The next two should be in a separate file */
==> HttpLookupRouterMapping :: [
    [path: '/about', type: `AboutHandler],
    [path: '/', type: `IndexHandler]
];

handleRequest = ^ ~HttpRequest => HttpResponse %% [h: HttpCompositeRequestHandler] :: {
    response = %h->shape(`HttpRequestHandler)(httpRequest)->shape(`HttpResponse);
};

main = ^Any => String :: 'Compilation successful. Please run from an HTTP adapter entry point';
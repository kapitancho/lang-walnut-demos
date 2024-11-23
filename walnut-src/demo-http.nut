module demo-http %% demo-http-db, generic-http, demo-http-config:

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

main = ^Array<String> => String :: {
    httpRequest = [
        protocolVersion: HttpProtocolVersion.HTTP11,
        headers: [
            Accept: ['text/html']
        ],
        body: '{"surveyTitle": "My first survey", "link": null, "surveyDescription": "My first attempt", "repeatableSurvey": false}',
        requestTarget: '/templates/10',
        method: HttpRequestMethod.GET
    ]->as(type{HttpRequest});
    httpResponse = HttpServer[]->handleRequest(httpRequest);
    httpRequest->printed->concatList['\n', httpResponse->printed]
};
module demo-autowire %% demo-http-db, generic-http, http-route, http-response-helper, demo-http-config:

Owner = [ownerId: Integer<1..>, name: String<1..>, ownershipPercent: Integer<1..100>];

OwnersHandler = ^[cityName: String, buildingId: Integer<1..>, args: [ownerId: Integer<1..>, ownershipPercent: Integer<1..100>]] => String;
GetOwnersHandler = ^[cityName: String, buildingId: Integer<1..>] => Array<Owner, 0..>;

InvalidJsonString ==> HttpResponse :: badRequest({'Invalid JSON body: '}->concat($->value));
HydrationError ==> HttpResponse :: badRequest({'Invalid request parameters: '}->concat($->errorMessage));
DependencyContainerError ==> HttpResponse :: internalServerError({'Handler error: '}->concatList[
    $->errorMessage, ': ', $->targetType->asString
]);
InvalidJsonValue ==> HttpResponse :: internalServerError({'Invalid handler result: '}->concat($.value->type->asString));

==> GetOwnersHandler :: ^[cityName: String, buildingId: Integer<1..>] => Array<Owner, 0..> :: [
    [
        ownerId: 1,
        name: 'John Doe',
        ownershipPercent: 100
    ],
    [
        ownerId: 2,
        name: 'Jane Doe',
        ownershipPercent: 50
    ]
];

==> OwnersHandler :: ^[cityName: String, buildingId: Integer<1..>, args: [ownerId: Integer<1..>, ownershipPercent: Integer<1..100>]] => String :: {
    'hi!'
};

handleRequest = ^HttpRequest => HttpResponse :: {
    request = #;
    /*#->DUMPNL;*/
    myRoute = HttpRoute[
        method: HttpRequestMethod.POST,
        pattern: RoutePattern('/cities/{cityName}/buildings/{+buildingId}/owners'),
        requestBody: JsonRequestBody['args'],
        handler: type{OwnersHandler},
        response: JsonResponseBody[200]
    ];
    myRoute2 = httpPatchJson[RoutePattern('/cities/{cityName}/buildings/{+buildingId}/owners'), type{OwnersHandler}, 'args'];
    myRoute3 = httpGetAsJson[RoutePattern('/cities/{cityName}/buildings/{+buildingId}/owners'), type{GetOwnersHandler}];

    myRouteChain = HttpRouteChain[routes: [myRoute, myRoute2, myRoute3]];
    response = myRouteChain->handleRequest(request);

    ?whenTypeOf(response) is {
        type{Result<Nothing, HttpRouteDoesNotMatch>}: notFound(request),
        type{HttpResponse}: response,
        ~: [
            statusCode: 200,
            protocolVersion: HttpProtocolVersion.HTTP11,
            headers: [:],
            body: 'oops'
        ]
    }
    /*response->DUMPNL;*/
    /*h1.conditionChecker(#)->DUMPNL;
    #.requestTarget->matchAgainstPattern('/cities/{cityName}/buildings/{buildingId}/owners')->DUMPNL;*/
};
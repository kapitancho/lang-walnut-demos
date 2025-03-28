module demo-todoapp-http %% $http/core, $http/route, $http/response-helper, demo-todoapp-controller:

TodoTaskHttpRouteChain = HttpRouteChain;

==> TodoTaskHttpRouteChain %% [~HttpRouteBuilder] ::
    HttpRouteChain[routes: [
        %httpRouteBuilder->httpPostJsonLocation[RoutePattern('/tasks'), type{AddTodoTask}, 'todoTaskData'],
        %httpRouteBuilder->httpDelete          [RoutePattern('/tasks/{taskId}'), type{RemoveTask}],
        %httpRouteBuilder->httpPost            [RoutePattern('/tasks/{taskId}/done'), type{MarkTaskAsDone}],
        %httpRouteBuilder->httpDelete          [RoutePattern('/tasks/{taskId}/done'), type{UnmarkTaskAsDone}],
        %httpRouteBuilder->httpGetAsJson       [RoutePattern('/tasks/{taskId}'), type{TodoTaskById}],
        %httpRouteBuilder->httpGetAsJson       [RoutePattern('/tasks'), type{ListTodoTasks}]
    ]];

TodoTaskHttpHandler = :[];
TodoTaskHttpHandler ==> HttpRequestHandler %% [~TodoTaskHttpRouteChain] :: {
    todoTaskHttpRouteChain = %.todoTaskHttpRouteChain;
    ^[request: HttpRequest] => Result<HttpResponse, Any> %% [~HttpResponseHelper] :: {
        request = #.request;
        response = ?whenTypeOf(todoTaskHttpRouteChain) is {
            type{HttpRouteChain}: todoTaskHttpRouteChain->handleRequest(request),
            ~: null
        };
        ?whenTypeOf(response) is {
            type{Result<Nothing, HttpRouteDoesNotMatch>}: %httpResponseHelper->notFound(request),
            type{HttpResponse}: response,
            ~: {
                [
                    statusCode: 200,
                    protocolVersion: HttpProtocolVersion.HTTP11,
                    headers: [:],
                    body: 'oops'
                ]
            }
        }
    }
};

InvalidJsonString ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->badRequest({'Invalid JSON body: '}->concat($->value));
HydrationError ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->badRequest({'Invalid request parameters: '}->concat($->errorMessage));
DependencyContainerError ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->internalServerError({'Handler error: '}->concatList[
    $->errorMessage, ': ', $->targetType->asString
]);
InvalidJsonValue ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->internalServerError({'Invalid handler result: '}->concat($value->type->asString));
CastNotAvailable ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->internalServerError(''->concatList[
    'Type conversion failure: from type ', $from->asString, ' to type ', $to->asString
]);

ExternalError ==> HttpResponse %% [~HttpResponseHelper] :: %httpResponseHelper->internalServerError({'External error: '}->concat($errorMessage));

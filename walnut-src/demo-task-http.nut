module demo-task-http %% http-core, http-route, http-response-builder, demo-task-api:

TaskHttpRouteChain = HttpRouteChain;

==> TaskHttpRouteChain ::
    HttpRouteChain[routes: [
        httpPostJsonLocation[RoutePattern('/tasks'), type{AddTask}, 'taskData'],
        httpDelete          [RoutePattern('/tasks/{taskId}'), type{RemoveTask}],
        httpPost            [RoutePattern('/tasks/{taskId}/done'), type{MarkTaskAsDone}],
        httpDelete          [RoutePattern('/tasks/{taskId}/done'), type{UnmarkTaskAsDone}],
        httpGetAsJson       [RoutePattern('/tasks/{taskId}'), type{TaskById}],
        httpGetAsJson       [RoutePattern('/tasks'), type{ListTasks}]
    ]];

TaskHttpHandler = :[];
TaskHttpHandler ==> HttpRequestHandler %% [~TaskHttpRouteChain, ~NotFound] :: {
    taskHttpRouteChain = %taskHttpRouteChain;
    ^[request: HttpRequest] => Result<HttpResponse, Any> :: {
        request = #request;
        response = ?whenTypeOf(taskHttpRouteChain) is {
            type{HttpRouteChain}: taskHttpRouteChain->handleRequest(request),
            ~: null
        };
        ?whenTypeOf(response) is {
            type{Result<Nothing, HttpRouteDoesNotMatch>}: %notFound(request),
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

InvalidJsonString ==> HttpResponse %% [~BadRequest] :: %badRequest({'Invalid JSON body: '}->concat($->value));
HydrationError ==> HttpResponse %% [~BadRequest] :: %badRequest({'Invalid request parameters: '}->concat($->errorMessage));
DependencyContainerError ==> HttpResponse %% [~InternalServerError] :: %internalServerError({'Handler error: '}->concatList[
    $->errorMessage, ': ', $->targetType->asString
]);
InvalidJsonValue ==> HttpResponse %% [~InternalServerError] :: %internalServerError({'Invalid handler result: '}->concat($value->type->asString));
CastNotAvailable ==> HttpResponse %% [~InternalServerError] :: %internalServerError(''->concatList[
    'Type conversion failure: from type ', $from->asString, ' to type ', $to->asString
]);

ExternalError ==> HttpResponse %% [~InternalServerError] :: %internalServerError({'External error: '}->concat($errorMessage));

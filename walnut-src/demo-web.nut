module demo-http %% demo-http-db, generic-http, demo-http-config:

State = $[value: Mutable<Integer>];
State->value(^Null => Integer) :: {
    $.value->SET({$.value->value} + 1);
    $.value->value
};

==> State :: State[Mutable[type{Integer}, 0]];

WebHandler = :[];
WebHandler->doHandle(^HttpRequest => HttpResponse) %% [r: CreateHttpResponse, s: State] :: {
    requestBody = #.body;
    bodyData = ?whenTypeOf(requestBody) is {
        type{String}: requestBody->jsonDecode,
        ~: => %.r(400)->withBody('Request body is required')
    };
    t = type{[op1: Integer, op2: Integer]};
    values = ?whenTypeOf(bodyData) is {
        type{JsonValue}: bodyData->hydrateAs(t),
        ~: => %.r(400)->withBody('Invalid request body. Json Expected')
    };
    values = ?whenTypeOf(values) is {
        t: values,
        ~: => %.r(400)->withBody('Invalid request body: [op1: Integer, op2: Integer] Expected')
    };
    %.r(200)->withBody({{values.op1 + values.op2} + %.s->value}->asString)
};

handleRequest = ^HttpRequest => HttpResponse :: {
    s = WebHandler[]->doHandle(#);
    ?whenTypeOf(s) is {
        type{HttpResponse}: s,
        ~: [
           statusCode: 500,
           protocolVersion: HttpProtocolVersion.HTTP11,
           headers: [:],
           body: ''
       ]
    }
};
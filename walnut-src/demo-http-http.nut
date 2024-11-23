module demo-http-http %% demo-http-domain, http-middleware:

TemplateHandler = :[];
TemplateHandler ==> HttpRequestHandler %% [~CreateHttpResponse, ~TemplateService] :: {
    ^[request: HttpRequest] => Result<HttpResponse, Any> :: {
        getSurveyTemplateIdFromRequest = ^HttpRequest => Result<SurveyTemplateId, Any> :: {
            templateId = {#.requestTarget->substringRange[start: 1, end: 9999]}=>asInteger->as(type{JsonValue});
            templateId=>hydrateAs(type{SurveyTemplateId})
        };
        getSurveyDetailsFromRequest = ^HttpRequest => Result<SurveyDetails, Any> :: {
            requestBody = #.body;
            bodyData = ?whenTypeOf(requestBody) is {
                type{String}: requestBody->jsonDecode,
                ~: null->as(type{JsonValue})
            };
            ?noError(bodyData)->hydrateAs(type{SurveyDetails})
        };

        surveyTemplateId = getSurveyTemplateIdFromRequest(#.request);
        requestBody = #.request.body;
        bodyData = ?whenTypeOf(requestBody) is {
            type{String}: requestBody->jsonDecode,
            ~: null->as(type{JsonValue})
        };
        body = getSurveyDetailsFromRequest(#.request);

        upd = ^[~SurveyTemplateId, ~SurveyDetails] => Result<Any, Any> ::
            %.templateService.updateDetails[#.surveyTemplateId, #.surveyDetails];

        code = ?whenValueOf(#.request.method) is {
            HttpRequestMethod.PATCH: ?whenTypeOf (
                m = upd[?noError(surveyTemplateId), ?noError(body)]
            ) is {
                type{TemplateUpdated}: 204,
                type{TemplateAdded}: 201,
                ~: 500
            },
            ~: 403
        };

        /*surveyTemplateId->DUMP;
        body->DUMP;*/
        %.createHttpResponse(code)
    }
};

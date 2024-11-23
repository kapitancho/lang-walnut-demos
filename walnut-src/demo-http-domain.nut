module demo-http-domain:

SurveyTitle = String<1..80>;
Link = String<1..255>|Null;
SurveyDescription = String|Null;
RepeatableSurvey = Boolean;
SurveyTemplateId = Integer<1..> ;
SurveyDetails = [~SurveyTitle, ~Link, ~SurveyDescription, ~RepeatableSurvey];

SurveyTemplate = [~SurveyTemplateId, ~SurveyDetails];

TemplateNotFound = $[~SurveyTemplateId];
TemplateAdded = $[~SurveyTemplateId];
TemplateUpdated = $[~SurveyTemplateId];
TemplateRemoved = $[~SurveyTemplateId];

SurveyTemplateRepository = [
    byId: ^ [~SurveyTemplateId] => Result<SurveyTemplate, TemplateNotFound|ExternalError>,
    store: ^ [~SurveyTemplate] => Result<TemplateAdded|TemplateUpdated, ExternalError>,
    remove: ^ [~SurveyTemplateId] => Result<TemplateRemoved, TemplateNotFound|ExternalError>,
    all: ^ Null => Result<Array<SurveyTemplate>, ExternalError>
];

TemplateService = [
    updateDetails: ^ [~SurveyTemplateId, ~SurveyDetails] => Result<TemplateAdded|TemplateUpdated, TemplateNotFound|ExternalError>,
    createSurveyTemplate: ^ [~SurveyTitle] => Result<Any, Any>,
    deleteSurveyTemplate: ^ [~SurveyTemplateId] => Result<Any, Any>
];

==> TemplateService %% SurveyTemplateRepository :: [
    updateDetails: ^ [~SurveyTemplateId, ~SurveyDetails] => Result<TemplateAdded|TemplateUpdated, TemplateNotFound|ExternalError> :: {
        tpl = ?noError(%.byId[#.surveyTemplateId]);
        tpl = tpl->with[surveyDetails: #.surveyDetails];
        %.store[tpl]
    },
    createSurveyTemplate: ^ [~SurveyTitle] => Result<Any, Any> :: null,
    deleteSurveyTemplate: ^ [~SurveyTemplateId] => Result<Any, Any> :: null
];

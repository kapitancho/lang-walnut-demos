module demo-http-db %% demo-http-domain, db:

DatabaseQueryResultRow ==> SurveyTemplate @ MapItemNotFound|CastNotAvailable|HydrationError :: [
    surveyTemplateId: ?noError($->item('id')->as(type{JsonValue})->hydrateAs(type{SurveyTemplateId})),
    surveyDetails: ?noError(
        {$->withKeyValue[key: 'repeatableSurvey', value: ?noError($->item('repeatableSurvey')) == 1]}
        ->as(type{JsonValue})->hydrateAs(type{SurveyDetails}))
];

SurveyTemplate ==> DatabaseQueryBoundParameters :: [
    id: $.surveyTemplateId,
    surveyTitle: $.surveyDetails.surveyTitle,
    link: $.surveyDetails.link,
    surveyDescription: $.surveyDetails.surveyDescription,
    repeatableSurvey: ?whenValueOf($.surveyDetails.repeatableSurvey) is {
        true: 1,
        false: 0
    }
];

defaultError = ^Null => ExternalError ::
    ExternalError[errorType: 'generic', originalError: null, errorMessage: 'Something went wrong'];

==> SurveyTemplateRepository %% DatabaseConnector :: [
    byId: ^ [~SurveyTemplateId] => Result<SurveyTemplate, TemplateNotFound|ExternalError> :: {
        data = %->query[query: 'SELECT id, survey_title AS surveyTitle, link, survey_description AS surveyDescription, repeatable_survey AS repeatableSurvey FROM survey_templates WHERE id = ?', boundParameters: [#.surveyTemplateId]];
        data = ?whenTypeOf(data) is {
            type{Result<Nothing, DatabaseQueryFailure>}: => Error(ExternalError[errorType: 'database', originalError: data, errorMessage: 'Database query failed']),
            type{DatabaseQueryResult}: data
        };
        row = data->item(0);
        surveyTemplate = ?whenTypeOf(row) is {
            type{Result<Nothing, IndexOutOfRange>}: => Error(TemplateNotFound[#.surveyTemplateId]),
            type{DatabaseQueryResultRow}: row->as(type{SurveyTemplate})
        }
    },
    store: ^ [~SurveyTemplate] => Result<TemplateAdded|TemplateUpdated, ExternalError> :: {
        data = %->query[
            query: 'SELECT id, survey_title AS surveyTitle, link, survey_description AS surveyDescription, repeatable_survey AS repeatableSurvey FROM survey_templates WHERE id = ?',
            boundParameters: [#.surveyTemplate.surveyTemplateId]
        ];
        data = ?whenTypeOf(data) is {
            type{Result<Nothing, DatabaseQueryFailure>}: => Error(ExternalError[errorType: 'database', originalError: data, errorMessage: 'Database query failed']),
            type{DatabaseQueryResult}: data
        };
        row = data->item(0);
        surveyTemplate = ?whenTypeOf(row) is {
            type{Result<Nothing, IndexOutOfRange>}: {
                params = #.surveyTemplate->as(type{DatabaseQueryBoundParameters});
                %->execute[
                    query: 'INSERT INTO survey_templates (id, survey_title, link, survey_description, repeatable_survey) VALUES (:id, :surveyTitle, :link, :surveyDescription, :repeatableSurvey)',
                    boundParameters: params
                ];
                TemplateAdded[#.surveyTemplate.surveyTemplateId]
            },
            type{DatabaseQueryResultRow}: {
                params = #.surveyTemplate->as(type{DatabaseQueryBoundParameters});
                %->execute[
                    query: 'UPDATE survey_templates SET survey_title = :surveyTitle, link = :link, survey_description = :surveyDescription, repeatable_survey = :repeatableSurvey WHERE id = :id',
                    boundParameters: params
                ];
                TemplateUpdated[#.surveyTemplate.surveyTemplateId]
            }
        }
    },
    remove: ^ [~SurveyTemplateId] => Result<TemplateRemoved, TemplateNotFound|ExternalError> :: Error(defaultError()),
    all: ^ Null => Result<Array<SurveyTemplate>, ExternalError> :: Error(defaultError())
];

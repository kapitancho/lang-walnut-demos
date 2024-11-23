module demo-clock %% datetime:

ClockTest = :[];
ClockTest->test(^Any => Any) %% [~Clock] :: {
    now = %.clock->now;
    myDate = Date[year: 2025, month: 4, day: 25];
    [
        now: now,
        year: now.date.year,
        myDate: myDate,
        invalidDate1: Date[year: 2025, month: 4, day: 31],
        invalidDate2: Date[year: 2025, month: 2, day: 30],
        invalidDate3: Date[year: 2025, month: 2, day: 29],
        validDate4: Date[year: 2028, month: 2, day: 29],
        invalidDate5: Date[year: 2100, month: 2, day: 29],
        validDate6: Date[year: 2400, month: 2, day: 29],
        hydrateDateFromString: '2024-02-29'->asJsonValue->hydrateAs(type{Date}),
        hydrateDateFromArray: [2024, 2, 29]->asJsonValue->hydrateAs(type{Date}),
        dateFromString: '2024-02-29'->asDate,
        hydrateTimeFromString: '12:34:56'->asJsonValue->hydrateAs(type{Time}),
        hydrateTimeFromArray: [12, 34, 56]->asJsonValue->hydrateAs(type{Time}),
        timeFromString: '12:34:56'->asTime,
        hydrateDateAndTimeFromString: '2024-02-29 12:34:56'->asJsonValue->hydrateAs(type{DateAndTime}),
        hydrateDateAndTimeFromArray: [2024, 2, 29, 12, 34, 56]->asJsonValue->hydrateAs(type{DateAndTime}),
        dateAndTimeFromString: '2024-02-29 12:34:56'->asDateAndTime
    ]
};

main = ^Any => String :: ClockTest[]->test->printed;

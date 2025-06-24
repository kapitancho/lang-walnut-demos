module demo-temperature %% fs:

DayTemperature = [day: String, temperature: Real];
String ==> DayTemperature @ Any :: {
    parts = $->split(':');
    [day: parts=>item(0)->trim, temperature: parts=>item(1)->trim=>asReal]
};
AverageNotAvailable := ();
calc = ^fileName: String => Result<[temperatures: Any, average: Real|AverageNotAvailable]> :: {
    data = {File[fileName]}
        =>content
        ->split('\n')
        =>map(^line: String => Result<DayTemperature, Any> :: line->trim->asDayTemperature);
    temperatures = data->map(^t: DayTemperature => Real :: t.temperature);
    tWithoutMinAndMax = {temperatures->sort->slice[start: 1]}->reverse->slice[start: 1];
    len = tWithoutMinAndMax->length;
    [
        temperatures: data,
        average: ?whenTypeOf(len) is {
            `Integer<1..>: {tWithoutMinAndMax->sum} / len,
            ~: AverageNotAvailable
        }
    ]
};

main = ^Array<String> => String :: calc('../walnut-src/temperature.txt')->printed;
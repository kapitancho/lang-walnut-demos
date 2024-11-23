module demo-temperature %% fs:

DayTemperature = [day: String, temperature: Real];
String ==> DayTemperature @ Any :: {
    parts = $->split(':');
    [day: parts=>item(0)->trim, temperature: parts=>item(1)->trim=>asReal]
};
calc = ^String => Result<[temperatures: Any, average: Real]> :: {
    data = {File[#]}
        =>content
        ->split('\n')
        =>map(^String => Result<DayTemperature, Any> :: #->trim->asDayTemperature);
    temperatures = data->map(^DayTemperature => Real :: #.temperature);
    tWithoutMinAndMax = {temperatures->sort->slice[start: 1]}->reverse->slice[start: 1];
    [
        temperatures: data,
        average: {tWithoutMinAndMax->sum} / tWithoutMinAndMax->length
    ]
};

main = ^Array<String> => String :: calc('temperature.txt')->printed;
module demo-fan %% event:

FanSpeed := (Stopped, Slow, Medium, Fast);

FanSpeed ==> String :: ?whenValueOf ($) is {
    FanSpeed.Stopped : 'Stopped',
    FanSpeed.Slow : 'Slow',
    FanSpeed.Medium : 'Medium',
    FanSpeed.Fast : 'Fast'
};

StartButtonPressed := ();
SpeedButtonPressed := ();
FanStarted := ();
FanStopped := ();
SpeedChanged := #[~FanSpeed];

StartButtonEventListener = ^StartButtonPressed => *Null;
SpeedButtonEventListener = ^SpeedButtonPressed => *Null;
FanStartedEventListener = ^FanStarted => *Null;
FanStoppedEventListener = ^FanStopped => *Null;
SpeedChangedEventListener = ^SpeedChanged => *Null;

FanIsAlreadyOn := ();
FanIsAlreadyOff := ();
FanIsNotOn := ();

Fan := $[speed: Mutable<FanSpeed>];
Fan() :: [speed: mutable{FanSpeed, FanSpeed.Stopped}];
Fan->isOn(=> Boolean) :: {$speed->value} != FanSpeed.Stopped;
Fan->turnOn(=> *Result<FanStarted, FanIsAlreadyOn>) %% [~EventBus] :: ?whenIsTrue {
    {$speed->value} == FanSpeed.Stopped : {
        $speed->SET(FanSpeed.Slow);
        %eventBus |> fire(FanStarted)
    },
    ~: @FanIsAlreadyOn
};
Fan->turnOff(=> *Result<FanStopped, FanIsAlreadyOff>) %% [~EventBus] :: ?whenIsTrue {
    {$speed->value} != FanSpeed.Stopped : {
        $speed->SET(FanSpeed.Stopped);
        %eventBus |> fire(FanStopped)
    },
    ~: @FanIsAlreadyOff
};
Fan->changeSpeed(=> *Result<SpeedChanged, FanIsNotOn>) %% [~EventBus] :: {
    newSpeed = ?whenValueOf($speed->value) is {
        FanSpeed.Stopped : => @FanIsNotOn,
        FanSpeed.Slow : FanSpeed.Medium,
        FanSpeed.Medium : FanSpeed.Fast,
        FanSpeed.Fast : FanSpeed.Slow
    };
    %eventBus |> fire(SpeedChanged[$speed->SET(newSpeed)->value])
};

==> StartButtonEventListener :: ^StartButtonPressed => *Null %% [~Fan] :: {
    'Start button pressed'->DUMPNL;
    ?whenIsTrue {
        %fan->isOn : %fan->turnOff *> ('Fan is already off'),
        ~: %fan->turnOn *> ('Fan is already on')
    };
    null
};
==> SpeedButtonEventListener :: ^SpeedButtonPressed => *Null %% [~Fan] :: {
    'Speed button pressed'->DUMPNL;
    %fan->changeSpeed *> ('Fan is not on');
    null
};

==> SpeedChangedEventListener :: ^SpeedChanged => *Null %% [~Fan] :: {
    'New fan speed: '->concat(#.fanSpeed->asString)->DUMPNL;
    null
};

==> FanStartedEventListener :: ^FanStarted => *Null %% [~Fan] :: {
    'Fan started'->DUMPNL;
    null
};

==> FanStoppedEventListener :: ^FanStopped => *Null %% [~Fan] :: {
    'Fan stopped'->DUMPNL;
    null
};

==> Fan :: Fan();

==> EventBus %% [
    ~StartButtonEventListener,
    ~SpeedButtonEventListener,
    ~SpeedChangedEventListener,
    ~FanStartedEventListener,
    ~FanStoppedEventListener
] :: EventBus[listeners: %->values];

TodoTest := ();
TodoTest->run(^Any => Any) %% [~EventBus] :: {
    pressStart = ^Null => Any :: %eventBus->fire(StartButtonPressed);
    pressSpeed = ^Null => Any :: %eventBus->fire(SpeedButtonPressed);
    pressStart();
    pressStart();
    pressSpeed();
    pressStart();
    pressSpeed();
    pressSpeed();
    pressSpeed();
    pressSpeed();
    pressStart();
    pressStart();
    pressSpeed();
    ['hello']
};

main = ^Any => String :: TodoTest->run->printed;

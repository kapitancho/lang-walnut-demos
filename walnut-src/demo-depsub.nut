module demo-depsub %% $datetime:

M := ();

T := #[~Clock];
S := #[~Clock] @ NotANumber :: null;
U := $[~Clock, ~M];
V := $[~Clock, ~M];
V[~M, ~T] %% [~Clock] :: [clock: #.t.clock, m: #.m];
Test := ();
Test->run(^Any => Any) %% [~T, ~S, ~U, ~V] :: [
    %t,
    %s,
    %u,
    %v,
    U[%t.clock, M],
    V[M, %t]
];

main = ^Any => String :: Test->run->printed;

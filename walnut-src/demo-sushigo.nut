module demo-sushigo:

SushiGoCard = :[
    Tempura, Sashimi, Dumpling,
    MakiRoll3, MakiRoll2, MakiRoll1,
    NigiriSquid, NigiriSalmon, NigiriEgg,
    Pudding, Wasabi, Chopsticks
];

SushiGoCard->cardName(^Null => String) :: {
    ?whenValueOf($) is {
        SushiGoCard.Tempura: 'Tempura',
        SushiGoCard.Sashimi: 'Sashimi',
        SushiGoCard.Dumpling: 'Dumpling',
        SushiGoCard.MakiRoll3: 'Maki Roll (3)',
        SushiGoCard.MakiRoll2: 'Maki Roll (2)',
        SushiGoCard.MakiRoll1: 'Maki Roll (1)',
        SushiGoCard.NigiriSquid: 'Nigiri (Squid)',
        SushiGoCard.NigiriSalmon: 'Nigiri (Salmon)',
        SushiGoCard.NigiriEgg: 'Nigiri (Egg)',
        SushiGoCard.Pudding: 'Pudding',
        SushiGoCard.Wasabi: 'Wasabi',
        SushiGoCard.Chopsticks: 'Chopsticks'
    }
};

SushiGoCard->numberOfCards(^Null => Integer<1..14>) :: {
    ?whenValueOf($) is {
        SushiGoCard.Tempura: 14,
        SushiGoCard.Sashimi: 14,
        SushiGoCard.Dumpling: 14,
        SushiGoCard.MakiRoll3: 8,
        SushiGoCard.MakiRoll2: 12,
        SushiGoCard.MakiRoll1: 6,
        SushiGoCard.NigiriSquid: 5,
        SushiGoCard.NigiriSalmon: 10,
        SushiGoCard.NigiriEgg: 5,
        SushiGoCard.Pudding: 10,
        SushiGoCard.Wasabi: 6,
        SushiGoCard.Chopsticks: 4
    }
};

SushiGoCardArray = Array<SushiGoCard, ..168>;

SushiGoCard->takeAllCards(^Null => Array<SushiGoCard, 1..14>) ::
    []->padLeft[length: $->numberOfCards, value: $];

SushiGoFullDeck = $[cards: SushiGoCardArray];

SushiGoFullDeck(Null) :: {
    result = type{SushiGoCard}->values->map(
        ^SushiGoCard => Array<SushiGoCard, 1..14> :: #->takeAllCards
    )->flatten;
    [cards: result]
};

SushiGoShuffledDeck = $[cards: Mutable<SushiGoCardArray>];
SushiGoShuffledDeck(SushiGoCardArray) :: [cards: Mutable[type{SushiGoCardArray}, #]];

SushiGoFullDeck->shuffle(^Null => SushiGoShuffledDeck) :: {
    SushiGoShuffledDeck($.cards->shuffle)
};


PlayerMove = [chosenCard: SushiGoCard, chopsticksExchange: Null|SushiGoCard];

PlayerName = String<1..20>;
PlayerList = $[players: Array<PlayerName, 2..8>];
PlayerList->cardsPerPlayer(^Null => Integer<4..10>) :: 12 - $.players->length;
PlayerList->players(^Null => Array<PlayerName, 2..8>) :: $.players;

PlayerCards = Array<SushiGoCard>;
PlayerCards->countCards(^SushiGoCard => Integer<0..>) :: {
    card = #;
    $->filter(^SushiGoCard => Boolean :: # == card)->length
};
PlayerCards->tempuraScore(^Null => Integer<0..>) :: {
    cards = $->countCards(SushiGoCard.Tempura);
    5 * {cards / 2}->asInteger
};
PlayerCards->sashimiScore(^Null => Integer<0..>) :: {
    cards = $->countCards(SushiGoCard.Sashimi);
    10 * {cards / 3}->asInteger
};
PlayerCards->dumplingScore(^Null => Integer<0..>) :: {
    cards = [$->countCards(SushiGoCard.Dumpling), 5]->min;
    {cards * {cards + 1} / 2}->asInteger
};
PlayerCards->makiScore(^Null => Integer<0..>) ::
    {
        {$->countCards(SushiGoCard.MakiRoll1)} +
        {2 * $->countCards(SushiGoCard.MakiRoll2)}
    } + {3 * $->countCards(SushiGoCard.MakiRoll3)};
PlayerCards->nigiriScore(^Null => Integer<0..>) ::
    {
        {3 * $->countCards(SushiGoCard.NigiriSquid)} +
        {2 * $->countCards(SushiGoCard.NigiriSalmon)}
    } + $->countCards(SushiGoCard.NigiriEgg);
PlayerCards->wasabiScore(^Null => Integer<0..>) :: 0;
    /*TODO*/
PlayerCards->puddingsCount(^Null => Integer<0..>) :: $->countCards(SushiGoCard.Pudding);

PlayersCards = $[cards: Map<PlayerCards>];
PlayersCards->scoreByPlayer(^Null => Map<Integer<0..>>) :: {
    cards = $.cards;
    cards->map(^PlayerCards => Integer<0..> ::
        [#->tempuraScore, #->sashimiScore, #->dumplingScore, #->makiScore, #->nigiriScore, #->wasabiScore
        ]->sum
    )
};
PlayersCards->withRemovedByPlayerMoves(^Map<PlayerMove> => Result<PlayersCards, MapItemNotFound|ItemNotFound>) :: {
    cards = $.cards;
    playerMoves = #;
    cards = cards=>mapKeyValue(^[key: String, value: PlayerCards] => Result<PlayerCards, MapItemNotFound|ItemNotFound> :: {
        playerCards = #.value;
        playerMove = playerMoves=>item(#.key);
        chosenCard = playerMove.chosenCard;
        chopsticksExchange = playerMove.chopsticksExchange;
        cards = playerCards=>without(chosenCard);
        cards = ?whenTypeOf(chopsticksExchange) is {
            type{SushiGoCard}: cards=>without(chopsticksExchange)->insertLast(SushiGoCard.Chopsticks),
            ~: cards
        }
    });
    PlayersCards[cards: cards]
};
PlayersCards->withAddedByPlayerMoves(^Map<PlayerMove> => Result<PlayersCards, MapItemNotFound|ItemNotFound>) :: {
    cards = $.cards;
    playerMoves = #;
    cards = cards=>mapKeyValue(^[key: String, value: PlayerCards] => Result<PlayerCards, MapItemNotFound|ItemNotFound> :: {
        playerCards = #.value;
        playerMove = playerMoves=>item(#.key);
        chosenCard = playerMove.chosenCard;
        chopsticksExchange = playerMove.chopsticksExchange;
        cards = playerCards->insertLast(chosenCard);
        cards = ?whenTypeOf(chopsticksExchange) is {
            /*type{SushiGoCard}: cards=>without(SushiGoCard.Chopsticks)->insertLast(chopsticksExchange),*/
            type{SushiGoCard}: cards=>insertLast(chopsticksExchange)->without(SushiGoCard.Chopsticks),
            ~: cards
        }
    });
    PlayersCards[cards: cards]
};
PlayersCards->passedToTheNextPlayer(^PlayerList => Result<PlayersCards, IndexOutOfRange|MapItemNotFound>) :: {
    playerList = #->players;
    cards = $.cards;
    cards = playerList=>mapIndexValue(^[index: Integer<0..>, value: PlayerName] => Result<PlayerCards, IndexOutOfRange|MapItemNotFound> :: {
        nextIndex = {#.index + 1} % playerList->length;
        cards->item(playerList=>item(nextIndex))
        /*
        nextPlayer = playerList->item(nextIndex);
        cards = cards=>insertLast(cards->item(value))->without(value);
        cards = cards->insertLast(cards->item(nextPlayer))->without(nextPlayer)*/
    });
    cards = playerList->flip=>map(^Integer => Result<Array<SushiGoCard>, IndexOutOfRange> :: cards=>item(#));
    PlayersCards[cards: cards]
};
PlayersCards->puddingsCountByPlayer(^Null => Map<Integer<0..>>) :: $.cards->map(^PlayerCards => Integer<0..> :: #->puddingsCount);

ActiveRound = $[playerList: PlayerList, openCards: PlayersCards, hiddenCards: PlayersCards];
ActiveRound->applyPlayerMoves(^Map<PlayerMove> => Result<ActiveRound, MapItemNotFound|ItemNotFound|IndexOutOfRange>) :: {
    playerList = $.playerList;
    openCards = $.openCards;
    hiddenCards = $.hiddenCards;
    playerMoves = #;
    ActiveRound[playerList,
        openCards=>withAddedByPlayerMoves(playerMoves),
        hiddenCards=>withRemovedByPlayerMoves(playerMoves)=>passedToTheNextPlayer(playerList)
    ]
};

CompletedGameRounds = $[playerList: PlayerList, cardsByRound: Array<PlayersCards, 3..3>, remainingDeck: SushiGoShuffledDeck];
CompletedGameRounds->totalScoreByPlayer(^Null => Result<Map<Integer>, MapItemNotFound>) :: {
    cardsByRound = $.cardsByRound;
    playerList = $.playerList;
    scoresByRound = cardsByRound->map(^PlayersCards => Map<Integer<0..>> :: #->scoreByPlayer);
    puddingCountsByRound = cardsByRound->map(^PlayersCards => Map<Integer<0..>> :: #->puddingsCountByPlayer);
    puddingCountsByPlayer = playerList->players=>flipMap(^PlayerName => Result<Integer<0..>, MapItemNotFound> ::
        {puddingCountsByRound->item(0)=>item(#) +
        puddingCountsByRound->item(1)=>item(#)} +
        puddingCountsByRound->item(2)=>item(#)
    );
    minPuddings = puddingCountsByPlayer->values->min;
    maxPuddings = puddingCountsByPlayer->values->max;
    playersWithMinPuddings = puddingCountsByPlayer->filter(^Integer => Boolean :: # == minPuddings)->keys;
    playersWithMaxPuddings = puddingCountsByPlayer->filter(^Integer => Boolean :: # == maxPuddings)->keys;
    pointsForMinPuddings = {6 / playersWithMinPuddings->length}->asInteger;
    pointsForMaxPuddings = {-6 / playersWithMaxPuddings->length}->asInteger;

    playerList->players->flipMap(^PlayerName => Result<Integer, MapItemNotFound> ::
        {{scoresByRound->item(0)=>item(#) +
        scoresByRound->item(1)=>item(#)} +
        scoresByRound->item(2)=>item(#)} +
        {?whenIsTrue { playersWithMinPuddings->contains(#) : pointsForMinPuddings, ~: 0 } +
        ?whenIsTrue { playersWithMaxPuddings->contains(#) : pointsForMaxPuddings, ~: 0 }}
    )
};

SushiGoShuffledDeck->dealCards(^PlayerList => Result<PlayersCards, ItemNotFound>) :: {
    players = #->players;
    deck = $.cards;
    cardsPerPlayer = #->cardsPerPlayer;
    cardsToDeal = cardsPerPlayer * players->length;

    cards = players=>flipMap(^PlayerName => Result<Array<SushiGoCard, 4..10>, ItemNotFound> ::
        1->upTo(cardsPerPlayer)->map(
            ^Integer => Result<SushiGoCard, ItemNotFound> :: deck=>POP)
    );
    PlayersCards[cards: cards]
};

testMove = ^Any => Any :: {
    players = PlayerList[players: ['Alice', 'Bob', 'Charlie', 'David', 'Eve']];
    hiddenCards = PlayersCards[cards: [
        Alice  : [SushiGoCard.MakiRoll2, SushiGoCard.MakiRoll3, SushiGoCard.Tempura, SushiGoCard.NigiriSquid],
        Bob    : [SushiGoCard.MakiRoll2, SushiGoCard.MakiRoll3, SushiGoCard.Sashimi, SushiGoCard.Chopsticks],
        Charlie: [SushiGoCard.Tempura, SushiGoCard.Tempura, SushiGoCard.Tempura, SushiGoCard.MakiRoll1],
        David  : [SushiGoCard.MakiRoll2, SushiGoCard.MakiRoll3, SushiGoCard.Sashimi, SushiGoCard.Wasabi],
        Eve    : [SushiGoCard.Dumpling, SushiGoCard.Chopsticks, SushiGoCard.NigiriSalmon, SushiGoCard.NigiriSquid]
    ]];
    openCards = PlayersCards[cards: [
        Alice  : [SushiGoCard.MakiRoll3, SushiGoCard.Chopsticks],
        Bob    : [SushiGoCard.Dumpling, SushiGoCard.Dumpling],
        Charlie: [SushiGoCard.Dumpling, SushiGoCard.Chopsticks],
        David  : [SushiGoCard.MakiRoll2, SushiGoCard.NigiriSquid],
        Eve    : [SushiGoCard.Wasabi, SushiGoCard.NigiriEgg]
    ]];
    ar1 = ActiveRound[players, openCards, hiddenCards];
    ar2 = ar1=>applyPlayerMoves[
        Alice  : [chosenCard: SushiGoCard.MakiRoll2, chopsticksExchange: null],
        Bob    : [chosenCard: SushiGoCard.Sashimi, chopsticksExchange: null],
        Charlie: [chosenCard: SushiGoCard.Tempura, chopsticksExchange: SushiGoCard.Tempura],
        David  : [chosenCard: SushiGoCard.Wasabi, chopsticksExchange: null],
        Eve    : [chosenCard: SushiGoCard.NigiriSalmon, chopsticksExchange: null]
    ];
    ar1->DUMPNL;
    ar2->DUMPNL
};

myFn = ^Array<String> => Any :: {
    deck = SushiGoFullDeck(null)->shuffle;
    players = PlayerList[players: ['Alice', 'Bob', 'Charlie', 'David', 'Eve']];
    drawnCards = [
        round1Cards = deck=>dealCards(players),
        deck=>dealCards(players),
        deck=>dealCards(players)
    ];
    c = CompletedGameRounds[playerList: players, cardsByRound: drawnCards, remainingDeck: deck];
    wasabi = SushiGoCard.Wasabi;
    testMove();
    [
        wasabi: wasabi,
        name: wasabi->cardName,
        cards: wasabi->numberOfCards
    ]->DUMPNL;
    [scoresByRoundAndPlayer: drawnCards->map(^PlayersCards => Map<Integer<0..>> :: #->scoreByPlayer)]->DUMPNL;
    [totalScoreByPlayer: c=>totalScoreByPlayer]->DUMPNL;
    [remainingCards: deck]->DUMPNL;
    [
        drawnByRoundAndPlayer: drawnCards
    ]
};

main = ^Array<String> => String :: {
    x = myFn(#);
    x->printed
};
% To print Everything
:- set_prolog_flag(answer_write_options,[max_depth(0)]).

generateNumbers(Low,High,_):-
    High =< Low,!,fail.
generateNumbers(Low,_,Result):-
    Result is Low.
generateNumbers(Low,High,Result):-
    L1 is Low + 1,
    generateNumbers(L1,High,Result).



board([
[0,3,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0]]).


solvedBoard([
    [5, 3, 4, 6, 7, 8, 9, 1, 2],
    [6, 7, 2, 1, 9, 5, 3, 4, 8],
    [1, 9, 8, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9]
]).

missingSquare([
    [0, 0, 0, 6, 7, 8, 9, 1, 2],
    [0, 0, 0, 1, 9, 5, 3, 4, 8],
    [0, 0, 0, 3, 4, 2, 5, 6, 7],
    [8, 5, 9, 7, 6, 1, 4, 2, 3],
    [4, 2, 6, 8, 5, 3, 7, 9, 1],
    [7, 1, 3, 9, 2, 4, 8, 5, 6],
    [9, 6, 1, 5, 3, 7, 2, 8, 4],
    [2, 8, 7, 4, 1, 9, 6, 3, 5],
    [3, 4, 5, 2, 8, 6, 1, 7, 9]
]).
board1([
    [5, 3, 4, 6, 0, 0, 0, 1, 2],
    [6, 7, 2, 1, 0, 5, 3, 0, 0],
    [1, 9, 8, 3, 4, 2, 5, 0, 0],
    [0, 5, 0, 0, 0, 1, 4, 0, 0],
    [0, 0, 0, 8, 5, 0, 7, 9, 0],
    [0, 0, 0, 9, 2, 0, 8, 5, 6],
    [9, 6, 1, 5, 3, 0, 2, 8, 0],
    [2, 0, 7, 4, 1, 9, 6, 0, 0],
    [0, 0, 0, 0, 8, 6, 0, 0, 0]
]).
validMove(Board,Line,Column,Number):-
    validLine(Board,Line,Number),
    validColumn(Board,Column,Number),
    validSquare(Board,Line,Column,Number).


getEmptyPosition(Board,Line,Column):-
    generateNumbers(0,9,Line),
    generateNumbers(0,9,Column),
    emptyPosition(Board,Line,Column).

emptyPosition(Board,Line,Column):-
    getPosition(Board,Line,Column,0).

getPosition(Board,Line,Column,Value):-
    nth0(Line,Board,LineList),
    nth0(Column,LineList,Value).

%setAt(Index,List,Value,Result)
setAt(0,[_|Y],Value,[Value|Y]):-!.
setAt(N,[X|Y],Value,[X|Z]):-
    N1 is N - 1,
    setAt(N1,Y,Value,Z).

setPosition(Board,Line,Column,Number,NewBoard):-
    nth0(Line,Board,LineList),
    setAt(Column,LineList,Number,NewLineList),
    setAt(Line,Board,NewLineList,NewBoard).

validLine(Board,Line,Move):-
    nth0(Line,Board,LineList),
    \+ ( member(Move,LineList)).
validColumn(Board,Column,Move):-
    
    \+ 
    (
        generateNumbers(0,9,CurrentLine),
        getPosition(Board,CurrentLine,Column,Move)
    ).
validSquare(Board,Line,Column,Move):-
    LineIndex is div(Line,3),
    ColumnIndex is div(Column,3),
    LineStart is 3 * LineIndex,
    ColumnStart is 3 * ColumnIndex,
    LineFinish is LineStart + 3,
    ColumnFinish is ColumnStart + 3,
    \+
    (
        generateNumbers(LineStart,LineFinish,CurrentLine),
        generateNumbers(ColumnStart,ColumnFinish,CurrentColumn),
        getPosition(Board,CurrentLine,CurrentColumn,Move)
    ).


solve(Solved,Solved):-
    \+
    (
    generateNumbers(0,9,Line),
    generateNumbers(0,9,Column),
    getPosition(Solved,Line,Column,0)
    ).

solve(Board,Result):-
    getEmptyPosition(Board,Line,Column),!,
    generateNumbers(1,10,Move),
    validMove(Board,Line,Column,Move),
    setPosition(Board,Line,Column,Move,NewBoard),
    solve(NewBoard,Result).

printLine([]).
printLine([X|XS]):-
    write(X),
    write(' '),
    printLine(XS).
printBoard([]).
printBoard([Line|Rest]):-
    printLine(Line),
    write('\n'),
    printBoard(Rest).

sudoku(Board):-
    solve(Board,Result),
    printBoard(Result),write('\n\n').

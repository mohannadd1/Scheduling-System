ta_slot_assignment([ta(Name, Load)|RestTAs], [ta(Name, NewLoad)|RestTAs], Name) :-
    Load > 0,
    NewLoad is Load - 1.

ta_slot_assignment([TA|RestTAs], [TA|NewRestTAs], Name) :-
    TA \= ta(Name,_),
    ta_slot_assignment(RestTAs, NewRestTAs, Name).
max_slots_per_day(DaySched, Max) :-
    \+ (member(SlotAssignments, DaySched),
        member(TA, SlotAssignments),
        count_occurrences(TA, DaySched, CountTA),
        CountTA > Max).



























count_occurrences(_, [], 0).
count_occurrences(Element, [List|Lists], Count) :-
    count(Element, List, Count1),
    count_occurrences(Element, Lists, Count2),
    Count is Count1 + Count2.

count(_, [], 0).
count(Element, [Element|Rest], Count) :-
    count(Element, Rest, Count1),
    Count is Count1 + 1.
count(Element, [X|Rest], Count) :-
    Element \= X,
    count(Element, Rest, Count).

slot_assignment(0,TAs,TAs,[]).
slot_assignment(LabsNum,TAs,[ta(Name,Loads)|RemTAs],[Name|Assignment]):-
    LabsNum > 0,
    LabsNum1 is LabsNum - 1,
    permutation(TAs, [ta(Name,_)|RemainingTAs]),
    ta_slot_assignment(TAs,UpdatedTAs,Name),
    select(ta(Name,Loads),UpdatedTAs,_),
    slot_assignment(LabsNum1,RemainingTAs,RemTAs,Assignment).

day_schedule([],TAs,TAs,[]).
day_schedule([H|T],TAs,Remtas,[H2|T2]):-
    slot_assignment(H,TAs,Inter,H2),
    day_schedule(T,Inter,Remtas,T2).

week_schedule([], _, _, []).
week_schedule([DaySlots|RestWeekSlots], TAs, DayMax, [Assignments|WeekSched]) :-
    day_schedule(DaySlots, TAs, RemTAs, Assignments),
    max_slots_per_day(Assignments, DayMax),
    week_schedule(RestWeekSlots, RemTAs, DayMax, WeekSched).
------------------------------- MODULE Either3 ------------------------------ 
EXTENDS Naturals, Sequences, TLC

(* --algorithm Either
      variables x = 0 ; y = 0 ; z = 0 ;
      begin a: either    x := 1 ; 
                      b: x := x + 1; 
                   or y := 1 ; c: y := y + 1;
                   or z := 100
               end either ;
            d: either when x = 0 ; z := z + 1 ;
                   or when x = 2 ; z := z + 3 ;
               end either ;     
               assert (x+y = 2) \/ ((z = 101) /\ (x+y=0));
               assert (z < 100) => (z = x + 1) ;
     end algorithm
*)

\* BEGIN TRANSLATION
VARIABLES x, y, z, pc

vars == << x, y, z, pc >>

Init == (* Global variables *)
        /\ x = 0
        /\ y = 0
        /\ z = 0
        /\ pc = "a"

a == /\ pc = "a"
     /\ \/ /\ x' = 1
           /\ pc' = "b"
           /\ UNCHANGED <<y, z>>
        \/ /\ y' = 1
           /\ pc' = "c"
           /\ UNCHANGED <<x, z>>
        \/ /\ z' = 100
           /\ pc' = "d"
           /\ UNCHANGED <<x, y>>

b == /\ pc = "b"
     /\ x' = x + 1
     /\ pc' = "d"
     /\ UNCHANGED << y, z >>

c == /\ pc = "c"
     /\ y' = y + 1
     /\ pc' = "d"
     /\ UNCHANGED << x, z >>

d == /\ pc = "d"
     /\ \/ /\ x = 0
           /\ z' = z + 1
        \/ /\ x = 2
           /\ z' = z + 3
     /\ Assert((x+y = 2) \/ ((z' = 101) /\ (x+y=0)), 
               "Failure of assertion at line 14, column 16.")
     /\ Assert((z' < 100) => (z' = x + 1), 
               "Failure of assertion at line 15, column 16.")
     /\ pc' = "Done"
     /\ UNCHANGED << x, y >>

Next == a \/ b \/ c \/ d
           \/ (* Disjunct to prevent deadlock on termination *)
              (pc = "Done" /\ UNCHANGED vars)

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(Next)

Termination == <>(pc = "Done")

\* END TRANSLATION

=============================================================================

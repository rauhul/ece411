# lecture 6

#### replacement policies for associative caches

least-recently-used LRU

-   evict the line that was used least recently
-   need to keep track of order of use
-   overhead gets worse as associativity increase

random

-   pick a line at random
-   really easy to implement
-   slightly lower hit rates than LRU on average

not most-recently-used

-   randomly evict a line that is not the most recently used
-   only need to track the line most recently used
-   comprise hit rate and implementation difficulty

virtual memories

-   dicussed later

#### LRU precise tracking

requires a stack for each cache set

-   when processor access a cache line
    -   take line id from stack and place on top
-   when evicting use the bottom of the stack, represents the LRU cache line

example, 4-way set associativity, A B C D

-   access pattern: C D A B A C B D
-   assuming stack is initially empty, [-,-,-,-]
    -   [C,-,-,-] D A B A C B D
    -   [D,C,-,-] A B A C B D
    -   [A,D,C,-] B A C B D
    -   [B,A,D,C] A C B D
    -   [A,B,D,C] C B D
    -   [C,A,B,D] B D
    -   [B,C,A,D] D
    -   [D,B,C,A]

given S-way associativity the stack requires $S\log_2S$ registers

#### LRU example

assume all valid initally

|          | MRU  | MRU-1 | LRU+1 | LRU  |      |
| -------- | ---- | ----- | ----- | ---- | ---- |
|          | A    | B     | C     | D    |      |
| access C | C    | A     | B     | D    | hit  |
| access D | D    | C     | A     | B    | hit  |
| access E | E    | D     | C     | A    | miss |
| access C | C    | E     | D     | A    | hit  |
| access G | G    | C     | E     | D    | miss |

#### LRU hardware perspective

state machine associated with LRU registers, used to update stack

lru policy increases cahce access times

-   additional hardware bits needed for LRU state machine

#### LRU approximate tracking (pseudo-LRU)

LRU stacks very expensive to implement at high 'S'

most modern caches use approxiate LRU

-   ​










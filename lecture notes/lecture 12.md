# lecture 12 notes

#### hardware Speculative Execution

- need buffer for results of uncommitted instructions
- buffer can be data source
- buffer results written to regifile in order
- easy to undo speculated instructions on mispredicts/exceptions

#### four steps of speculative tomasulo

 - issue—get instruction from FP Op Queue
    - if RS and ROB slots are free
    - issue instruction + operands
    - update ROB
 - execution
    - same as normal tomasulos
 - finish execution (WB)
    - write result to central data buss
    - updated dependent RS's + ROB, clear RS
 - commit new register value
    - when head of ROB has result, push all available values into regifle in order
    - remove from ROB


> see example (10+ slides working out example)

#### speculative execution
 - ROB allows us to flush the speculative instructions as needed
 - ROB another possible source of operands
 - ROB provids in-order commit
 - ROB allows us to precisely handle exceptions


#### issues
 - number of RS's and ROB grows with number of instructions in flight
 - cpu can only look at limited window of instructions
    - decide which to issue
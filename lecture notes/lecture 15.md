# lecture 15 notes

how does a processor interact with other devices

how to get events

how to transfer large amounts of data

#### I/O devices

I/O devices allow the CPU to interact with external stimuli 

solution 1

- unified memory + I/O interconnect

solution 2 

- Decouple I/O from interconnect
- add additional I/O controller between device and interconnect

solution 3

- Separare high performance processor, memory, display interconenct from low performance interconnect via bridge
- north bus
  - short, fast & wide, fixed topology
  - CPU, Caches, Memory controllers
- south bus
  - longer, slower & narrower
  - flexible topology
     interoperability with many standards
  - connect to north bus via bridge

previsouly interconects were busses

- parallel set of wires for data and control
- bus protocol

more common now

- dedicated point to point channels

Diverse I/O devices require hierarchical interconnect, transitioning to point-to-point topologies

#### I/O Device API

set of read-only and r/w registers

- command registers
  - write to these to cause the device to perform an action
- status register
  - value indicates what the device is during + error codes
- data registers
  - r/w to transfer data back and forth

#### Communication interface

progammed I/O

- Interact with cmd status and data device registers directly
- only allowed in kernel mode, crossing this boundry is a very expensive operation
- requires special instructions
- can require dedicated hardware interface to deivces
- difficult to virtualize

map registers into virtual address space

- much faster than direct register manipulation
- data travels via memory bus
- protection via page table bits
- re-uses stand load/store instructions

polling

- periodically check I/O status register
- based on reponse take different actions
- pros
  - predictable timing and inexpensive 
  - efficient if there is always works to do
- cons
  - wastes CPU time polling

interrups

- device sends interrup to CPU
- handler examines device and determines what to do
- can introduce different priorities for the interrupts
- pros
  - more efficient, only use CPU time when CPU needs to take action in response to device
- con
  - Unpredictable, because event arrival is dependent on other devices

combined

- use interrupts to start polling for devices that send events in bursts

#### I/O Data Transfer

reading via load instructions is very very expensive

introduce structure called Direct Memory Access DMA

- os provides base address and length
- DMA controller transfers data sutonomously
- interrupt on completion/error
- cpu sets up dma, instead directly managing the data transfer

issue 1 virtual memory

- OS sets up mapping for the DMA
- uses mini TLB

issue 2 paged virtual memory

- pin destination page
- or could use bounce buffer where DMA pinned to kernel and memcpy to correct page

issue 3 caching

- DMA data could be in L1/L2 caches
- DMA to memory makes the cache data stale
- memory to DMA makes the device data stale
- Solution coherence via snooping
- cache litstens on bus and takes control as needed
- other solution, flush caches before transfers




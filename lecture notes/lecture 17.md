# lecture 16 notes

#### Why multi-core

hard to to increase signle core frequencies higher

- hard to extract more ILP becuase larger instruction windows introduce slow/power expensive circuits

deep pipelines

- heat problems
- hard to D&V

#### how to reduce power consumption 

- Multi-core
  - one core at 2GHz vs two cores at 1GHz
  - Same performace with $\frac{2}{8} \text{ the total power, since }P \alpha f^3$
- new challenge
  - how to fully utilize all cores

#### thermal limits

thermal limits can prevent all components in the CPU running concurrently

#### ILP vs TLP

instruction level parallelism 

- at the instruction level
- cpu can re-order and pipeline instructions
- enabled rapid increases in processor speeds over last 15 years

thread level parallelism

- coarser scale
- server can response to each client on a distinct thread
- computer can run tools on differnt threads
- single-core super scalar processors cannot fully exploit TLP
- Multi-core can

#### multi-core CPU

as the name suggests multiple cores per socket

- can still run multiple threads per core (time-sliced)
- OS schedules threads to different cores which appear as distinct processors

different implementations

- SIMD
  - single instruction - multiple data
  - modern gpus
- MIMD
  - multiple instruction - multiple data
  - multi-core cpus

#### multi-cpu

shared common memory for all processors

distruted memory, each processor has its own memory as well

#### simultaneous multi-threading SMT

processor can be stalled waiting for the result of a long floating point operation, or memory access

- many resources are left unused
- allows multiple independent thread to run concurrently
- weaving together mutliple threads on the same core
  - ie one thread waiting for flop result, other thread can use integer compute units
- not a true parallel processor
  - enables better threading up to ~30%
  - OS perceieves core as two separate virtual processors
  - always worse than true cores

#### memory hierarhcy

private caches

- closer to core, faster access time
- less contention

shared cahces

- threads on different caches can share data
- more cache space available to a few high-performance threads

#### cache coherence

since we have private caches how do we keep data consistent

each core believes memory is one monolithic contingous array (virtual memory)

MESI coherence protocol, essentialy snoop and invalidate other cache entries
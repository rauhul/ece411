# lecture 5

#### types of memory

| Type           | Size       | Latency | Cost/bit |
| -------------- | ---------- | ------- | -------- |
| register       | < 1kB      | < 1ns   | $$$$     |
| on-chip SRAM   | 8kB - 6MB  | < 2ns   | $$$      |
| off-chip SRAM  | 1MB - 16MB | < 10ns  | $$       |
| DRAM           | 64MB - 1TB | < 100ns | $        |
| Disk (SSD, HD) | 40GB - 1PB | < 20ms  | < $1/GB  |

capacity is inversely proportionate to speed and cost

#### why does a hierachy work

locality of reference 

-   temporal locality
    -   reference same memory location many times (close together in time)
-   spatial locality
    -   reference near neighbors around the same time

#### example of locality 

>   huh? don't understand this slide

#### memory hierahcy

CPU <-> (instruction + data) L1 cache <-> shared L2 cache <-> L3? <-> main memory <-> disk

temporal locality

-   keep recently referenced items at higher cache levels
-   future references to these locations are satisfied quickly

spatial locality

-   bring neighbors of recent referenced locations to higherlevels
-   could be used bring instructions that could be used soon up to higher levels
    -   future references satisfied quickly

#### example Intel Nehalem memory hierarchy

-   4-way set associative instruction cache
-   8-way set associative L1 data cache 32kB
-   8-way set associative L2 data cache 256kB
-   16-way set associative L3 data cache 8MB
-   3 DDR3 memory connections

#### typical memory organization

![IMG_C142ABA7A044-1](./IMG_C142ABA7A044-1.jpeg)

use address to determine which row to access, then use address to decode which column to use

#### cache terminology

hit, requested data appears in the cache

-   hit rate, percentage time requested data is in the cache
-   hit time, time to acces the cache level, RAM access time and time to dertmine hit

miss, request data is not in cache level, must access lower level

-   miss rate, opposite of hit rate
-   miss penalty, time to replace a block in the upper level and deliver data to processor

hit time << miss penalty

#### average memory-access time (AMAT)

$$
\begin{align*}
\text{hit time}*\text{miss rate} &\approx 0 \\
\text{AMAT} &= \text{hit time}*(1-\text{miss rate}) + \text{miss penalty}*\text{miss rate} \\
&= \text{hit time} - \text{hit time}*\text{miss rate} + \text{miss penalty}*\text{miss rate}\\
&= \text{hit time} + \text{miss penalty}*\text{miss rate}\\
\end{align*}
$$

miss penalty

-   access time: function latency
-   transfer time: function of bandwidth bewteen cache levels
    -   transfer one cache line at a time
    -   transfer at the size of the memory-bus width

#### calculating memory heirarhcy performance

example

-   cache hit, 1 cycle
-   miss rate = 0.1
-   miss penalty, 300 cycles

$\text{AMAT} = 1\text{ cycle} + 0.1 * 300\text{ cycles} = 31\text{ cycles}$

![IMG_1E91579FF4A9-1](./IMG_1E91579FF4A9-1.jpeg)

#### reduce AMAT by using a multi-level cache

example

|            | miss rate | hit cycles |
| ---------- | --------- | ---------- |
| L1         | 0.1       | 1          |
| L2         | 0.05      | 10         |
| L3         | 0.01      | 20         |
| M (memory) |           | 300        |


$$
\begin{align*}
\text{AMAT} &= L1_{hit} + L1_{miss}*(L2_{hit} + L2_{miss}*(L3_{hit} + L3_{miss}*(M_{hit}))) \\
&=1 + 0.1*(10 + 0.05*(20 + 0.01*(300))) \\
&=2.115
\end{align*}
$$

AMAT substantially faster than the single level Implementation

-   $\frac{31}{2.115} = 14.66$ times faster

#### types of caches

| types of cache         | Cache memory to data mapping                           | cache search complexity                       |
| ---------------------- | ------------------------------------------------------ | --------------------------------------------- |
| direct mapped (DM)     | data only has one possible location it could be placed | very fast lookup/indexing mechanism           |
| set-associative (SA)   | data can be placed in any cachline in the set          | slightly more involved search mechansim       |
| fully-associative (FA) | data can be placed in any cachline in the entire cache | requries very extensive search hardware (CAM) |

![IMG_4C286D22440E-1](./IMG_4C286D22440E-1.jpeg)

#### three Cs, cache miss terms

-   compulsory misses
    -   cold start miss
    -   cache does not have valid data at the start of the program
-   capacity misses
    -   increase cache size
-   conflict misses
    -   increase cache size or
    -   increase associativity

#### four questions when designing a cache

P-I-R-W

-   placement, where can a block of memory go?
    -   associativity
-   identification, how do I find a block of memory?
    -   tag + index bits
-   replacement, how do I make space for a new block?
    -   how to determine which block to evict if multiple
    -   LRU
-   write policy, how do I propagate changes?
    -   write through
    -   write back

must consider this for all cache levels

-   only L1, L2, L3 for now

#### describing caches, 7 parameters

-   access time, $T_{hit}$
-   capacity
    -   total size of the cache
    -   $\text{#lines}\times\text{line size}$
-   line size
    -   amount of dtaa that moves in or out of the cache as a chunk
    -   similar to page size for virtual memory
-   replacement policy
    -   what data if any is replaced on a miss
    -   write-allocate
    -   no write-allocate
-   associativity
    -   how many locations can a line be placed in
    -   DM, SA, FA
-   data type
    -   unified, data, instructions
    -   what data is in the cache

#### example

1kB DM cache, 32-Byte line, 32 sets

-   address, 32 bits long
    -   offset, bottom 5 bits, used to address bytes within the cache line $2^5 = 32$
    -   index, next 5 bits, used to index to the correct line (not set because DM)
    -   rest of the bits are tag
    -   tag[31:10], index[9:5], offset[4:0]

#### example 2

2MB DM cache, 64-Byte line, 52 bit physical address

$$
\begin{align*}
2MB &= 2*2^{20} \\
64B &= 2^6 \\
\text{# cache lines}&=\frac{2MB}{64B}=\frac{2*2^{20}}{2^6}=2^{15} \\
\text{# bits for index} &= \log_2(2^{15}) = 15 \\
\text{# bits for offset} &= \log_2(64) = 6 \\
\end{align*}
$$

-   address, 52 bits long
    -   offset, bottom 6 bits, used to address bytes within the cache line
    -   index, next 15 bits, used to index to the correct line (not set because DM)
    -   rest of the bits are tag
    -   tag[51:21], index[20:6], offset[5:0]


now change it to 16-way

-   \# cache lines decreases by factor of 16, $\frac{2^{15}}{2^{4}}=2^{11}$
-   offset, bottom 6 bits, used to address bytes within the cache line
-   index, next **11** bits, used to index to the correct set
-   tag[51:17], index[16:6], offset[5:0]

now change it to fully associative 

-   offset, bottom 6 bits, used to address bytes within the cache line
-   no index bits
-   tag[51:6], offset[5:0]
-   
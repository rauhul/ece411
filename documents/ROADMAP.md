# Roadmap

## Checkpoint 1
In checkpoint 2, we will be finishing all other lc-3b instructions, caches, and wishbone interconnect and paper design for data forwarding.
Overall, we are going to split parts and combine and debug. These are the assignments for the parts.

Handle all lc-3b instructions - by all 3~4 instructions each

Wishbone interconnect - Won Jae

L1, L2 caches - Rauhul

multi-cycle L2 accesses - Kyung Jae

paper design for data forwarding - Won Jae, Rauhul

## Checkpoint 2
In checkpoint 3, we will add an L2 cache to our cache hierarchy. It will be mostly a copy of the L1 cache but with 8-way associativity and 256-bit lines. We will also implement data forwarding through the use of another module that interacts with our stall controller.

## Checkpoint 3
In checkpoint 4, we will debug the failures we see in the competition code. We will also change the branch_controller to make static predicitons instead of stalling when branch instructions are seen. Additionally, we will add an evicition write buffer and performance counters. We would also like to have a large suite of hazardous tests so we can rigorously test our pipeline.

## Checkpoint 4
In checkpoint 5, we will debug potential issues with a WAW hazard detection in the pipeline. We will also implement a form of dynamic branch prediction as well. Additionally, we will implement cacheline_prefetching for the i_cache to dramatically reduce stalls in the pipeline.

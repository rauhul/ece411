# lecture 18 notes

SISD

- single instruction, single data
- single core cpu no SMT

SIMD

- single instrution, multiple data
- vector processor, GPU

MISD

- not used

MIMD

- multiple instruction, multiple data
- multi-core, smt, or multi-processor

#### Why SIMD

pros

- more parallelism
  - SIMD + ILP
- simple design
- energy efficent
- small die area


cons

- explicitly exposed to hardware
- complier or programmer optimized

essentially ece 408 material

#### VLIW

- very long instruction word
- similar to RISC
  - however multiple instructions in parallel
- compiler finds parallelism
- pros
  - no need for dynamic scheduling
  - no dependency checking
  - no isntruction alignment
  - all make the hardware simplier
- cons
  - compiler needs to find N independent instructions
  - otherwise adds nops
  - wastes parallism and code size is larger
  - recompliation when N changes
  - lockstep causes independent ops to stall
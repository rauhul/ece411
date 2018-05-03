# lecture 10 notes

#### low power design techniques

- cheating
  - reducing the performance of the design
- reduce waste
  - dont use engery for actions with no result
  - introduce parallelism to reduce waiting time
- problem reformulation
  - reduce computational cost

#### cmos circuit delay and frequency

$P = \frac{1}{2}C_{sw}V_{dd}\Delta V f + I_{st}V_{dd} + I_{static}V_{dd}$

frequency determined by sum of progrogation delays along critical apth

- each generation gate delay reduced by ~30%
  - in practice frequency inceases by 2 (delay reduced ~50%)
  - due to shorter cirtical paths and deeper pipelines

#### active power reduction

capacitance minimization

 - power/performace in sizing
 - Clock-gating
 - glitch-suppresion
 - hardware accelerators
 - SOC integration

voltage minimization

- dynamic voltage scaling
- low swing signaling

frequency minization

- dynamic frequency scaling

#### capacitance minimization

- $C_{sw}$ component
- only the devices (device width) used in the design consume active power

##### functional clock gating

- 25-50% of power conumption due to driving flip-flops
- utilzation of latchs relatively low
- clock gate unused flip/flips and associated logic when not in use
  - unit level clock gating, or IP level clock gating

##### glitch suppression

can represent a sizeable portion of active power, up to 30%

how to avoid?

- add redundant logic to avoid glitches
  - increases capcitance
  - hard to test
- adjust delays in the design

#### voltage minimization

- $V_{dd}\Delta V$ component

lowering supply is most promising

- $f \alpha V$, so $P\alpha V^3$

custom cpus, analog circuits, plls, I/O deiver dont scale with voltage easily

##### dynamic voltage scaling

!!

#### frequency minization

- $f$ component

##### dynamic frequency scaling

lowers power linearly

does not improve energy efficieny

- slows down the cpu
- lower peak power
- Important for avoiding thermal problems

#### static power

- $ I_{static}(V_{dd},t_{ox},V_{t})$ component
- standby power can be reduced through:
  - capacitance minimization
    - leakage current is proportional to the size of transistors
  - voltage-scaling
  - power gating
  - Vdd/Vt selection

##### voltage scaling

decreasing supply voltage greatly improves standby power

##### power gating

transistors still leak when clock is off

remove supply completely from unit/functional group/IP

- sleep states (C state)
- lower idle power, but longer wake-up latency, the deeper the C state

when theres low work

- slow down clokc
- or sleep to reduce power and wait for enqueued work to pass a threshold

#### problem reformulation

best way to save energy is to do less work

- energy is directly reduced by the reduction in computational load, execution time also decreases

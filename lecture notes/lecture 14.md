# lecture 14 notes

understand IEEE-754 floating point

- Made of three parts
  - sign
  - mantissa 
  - exponent
- value comes from $-1^s*M*2^E$

##### mantissa

mantissa is in the range [1, 10) base 2, this makes each bit pattern unique

- since all values start with 1, this value is omited
- mantissa without leading one is called fraction

##### exponent

in an n-bit exponent representation, $2^{n-1}-1$ is added to the 2s complement representation to form the excess representation

- ex, 3-bit
  - 000
    - 2's compliment decimal -> 0
    - Excess-3 -> 011
  - 011
    - decimal -> 3
    - Excess-3 -> 110
  - 100 
    - reserved bit pattern
    - Excess-3 -> 111
- simple unsigned integer comparator can be used to compare the magnitude of two floating point numbers
- symetric exponent range +/-
  - all 1s is a reserved exponent for special cases

#### hypothetical 5-bit floating point

- assuming 1-bit S, 2-bit M, and 2-bit E
- how to represent decimal 0.5
- sign -> 0
- mantissa = (1.)00
- exponent = -1 -> $-1+2^{2-1}-1= -1+2-1 = 0$ -> 00

0.5 -> 00000

#### Representable Numbers

- Set of representable numbers

flushing to zero greatly reduces this

- assume all 0s exponent is 0 regardless of mantissa
- lumps all values near zero into 0, for large M, we lose a lot of representable numbers

bad idea to use this method of getting the value 0

- lots of calucations require the use of number very close to 0

#### Denormalized Numbers

instead we use a method called denormalized numbers

assume mantissa is in the form 0.xx when the E = 0

#### IEEE 754 formats

- single precision
  - 1-bit sign
  - 8-bit exponent (+ 127 excess)
  - 23-bit fraction
- double precision
  - 1-bit sign
  - 11-bit exponent (+ 1023 excess)
  - 52-bit fraction
  - largest error is reduced to $\frac{1}{2^{29}}$ that of single precision


#### Special bit patterns
| Exponent | Mantissa | Meaning      |
| -------- | -------- | ------------ |
| all 1s   | non-zero | NaN          |
| all 1s   | zero     | pos/neg inf  |
| all 0s   | non-zero | denormalized |
| all 0s   | zero     | 0            |

#### Rounding and Error

Assume same 5-bit representation

some numbers cannot be accurately added because the resulting magnitude means the least significant fractional bits are lost, ex:
$$
1.0*2^{-2} + 1.0*2^1 \leftrightarrow 0;00;01 + 0;10;00\\
\text{hardware needs to shift the mantissa bits in order to align them} \\
1.0*2^{-2} + 1.0*2^1 \leftrightarrow 0;00;001 + 0;10;00\\
1.001  \leftrightarrow 0;10;001\\
\text{requires more mantissa bits than are avaliable}
$$

#### Order of operations

Due to roounding errors FLOPS are not strictly associative

- very small numbers can be lost when added to or subtracted from a very large number
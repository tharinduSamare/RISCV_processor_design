[Source](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)

# Unconditional Jumps

## JAL

- J format.
- J-immediate encodes a signed ofset in multiples of 2 bytes.
- Offset is sign-extended add added to pc to get the next jump target address.
- targets ±1 Mib range.
- PC + 4 is stored in register rd.
- The standard software calling convention uses x1 as the return address register and x5 as an alternate link register.

# Indirect Jump

## JALR

- Uses I-type encoding.
- The target address is obtained by adding the 12-bit signed I-immediate to the register rs1.
- Then set the least-significant bit of the result to zero.
- The address of the instruction following the jump (pc + 4) is written to register rd.
- Register x0 can be used as the destination if the result is not required.

# Conditional Branching

- All branch instructions use the B-type instruction format.
- 12-bit B-immediate encodes signed offsets in multiples of 2.
- B-immediate is added to the current pc to give the target address.
- The conditional branch range is ±4 KiB
- Branch instructions **compare two registers**

## BEQ

- Take the branch if registers rs1 and rs2 are equal.

## BNE

- Take the branch if registers rs1 and rs2 are unequal.

## BLT

- Take the branch if rs1 is less than rs2
- Signed

## BLTU

- Take the branch if rs1 is less than rs2
- Unsigned

## BGE

- Take the branch if rs1 is greater than or equal rs2
- Signed

## BGEU

- Take the branch if rs1 is greater than or equal rs2
- Unsigned

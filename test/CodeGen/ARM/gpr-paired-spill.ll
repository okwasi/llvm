; RUN: llc -mtriple=armv7-none-linux-gnueabi < %s | FileCheck %s

define void @foo(i64* %addr) {
  %val1 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val2 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val3 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val4 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val5 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val6 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)
  %val7 = tail call i64 asm sideeffect "ldrd $0, ${0:H}, [r0]", "=&r,r"(i64* %addr)

  ; Key point is that enough 64-bit paired GPR values are live that
  ; one of them has to be spilled. This used to cause an abort because
  ; an LDMIA was created with both a FrameIndex and an offset, which
  ; is not allowed.

  ; We also want to ensure the register scavenger is working (i.e. an
  ; offset from sp can be generated), so we need two spills.
; CHECK: add [[ADDRREG:[a-z0-9]+]], sp, #{{[0-9]+}}
; CHECK: stm [[ADDRREG]], {r{{[0-9]+}}, r{{[0-9]+}}}
; CHECK: stm sp, {r{{[0-9]+}}, r{{[0-9]+}}}

  ; In principle LLVM may have to recalculate the offset. At the moment
  ; it reuses the original though.
; CHECK: ldm [[ADDRREG]], {r{{[0-9]+}}, r{{[0-9]+}}}
; CHECK: ldm sp, {r{{[0-9]+}}, r{{[0-9]+}}}

  store volatile i64 %val1, i64* %addr
  store volatile i64 %val2, i64* %addr
  store volatile i64 %val3, i64* %addr
  store volatile i64 %val4, i64* %addr
  store volatile i64 %val5, i64* %addr
  store volatile i64 %val6, i64* %addr
  store volatile i64 %val7, i64* %addr
  ret void
}
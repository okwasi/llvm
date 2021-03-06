; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl | FileCheck %s

; CHECK-LABEL: test1
; CHECK: vcmpleps
; CHECK: vmovups
; CHECK: ret
define <16 x float> @test1(<16 x float> %x, <16 x float> %y) nounwind {
	%mask = fcmp ole <16 x float> %x, %y
	%max = select <16 x i1> %mask, <16 x float> %x, <16 x float> %y
	ret <16 x float> %max
}

; CHECK-LABEL: test2
; CHECK: vcmplepd
; CHECK: vmovupd
; CHECK: ret
define <8 x double> @test2(<8 x double> %x, <8 x double> %y) nounwind {
	%mask = fcmp ole <8 x double> %x, %y
	%max = select <8 x i1> %mask, <8 x double> %x, <8 x double> %y
	ret <8 x double> %max
}

; CHECK-LABEL: test3
; CHECK: vpcmpeqd
; CHECK: vmovdqu32
; CHECK: ret
define <16 x i32> @test3(<16 x i32> %x, <16 x i32> %y) nounwind {
	%mask = icmp eq <16 x i32> %x, %y
	%max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %y
	ret <16 x i32> %max
}

; CHECK-LABEL: @test4_unsigned
; CHECK: vpcmpnltud
; CHECK: vmovdqu32
; CHECK: ret
define <16 x i32> @test4_unsigned(<16 x i32> %x, <16 x i32> %y) nounwind {
	%mask = icmp uge <16 x i32> %x, %y
	%max = select <16 x i1> %mask, <16 x i32> %x, <16 x i32> %y
	ret <16 x i32> %max
}

; CHECK-LABEL: test5
; CHECK: vpcmpeqq {{.*}}%k1
; CHECK: vmovdqu64 {{.*}}%k1
; CHECK: ret
define <8 x i64> @test5(<8 x i64> %x, <8 x i64> %y) nounwind {
	%mask = icmp eq <8 x i64> %x, %y
	%max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %y
	ret <8 x i64> %max
}

; CHECK-LABEL: test6_unsigned
; CHECK: vpcmpnleuq {{.*}}%k1
; CHECK: vmovdqu64 {{.*}}%k1
; CHECK: ret
define <8 x i64> @test6_unsigned(<8 x i64> %x, <8 x i64> %y) nounwind {
	%mask = icmp ugt <8 x i64> %x, %y
	%max = select <8 x i1> %mask, <8 x i64> %x, <8 x i64> %y
	ret <8 x i64> %max
}

; CHECK-LABEL: test7
; CHECK: xor
; CHECK: vcmpltps
; CHECK: vblendvps
; CHECK: ret
define <4 x float> @test7(<4 x float> %a, <4 x float> %b) {
  %mask = fcmp olt <4 x float> %a, zeroinitializer
  %c = select <4 x i1>%mask, <4 x float>%a, <4 x float>%b
  ret <4 x float>%c
}

; CHECK-LABEL: test8
; CHECK: xor
; CHECK: vcmpltpd
; CHECK: vblendvpd
; CHECK: ret
define <2 x double> @test8(<2 x double> %a, <2 x double> %b) {
  %mask = fcmp olt <2 x double> %a, zeroinitializer
  %c = select <2 x i1>%mask, <2 x double>%a, <2 x double>%b
  ret <2 x double>%c
}

; CHECK-LABEL: test9
; CHECK: vpcmpeqd
; CHECK: vpblendmd
; CHECK: ret
define <8 x i32> @test9(<8 x i32> %x, <8 x i32> %y) nounwind {
  %mask = icmp eq <8 x i32> %x, %y
  %max = select <8 x i1> %mask, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %max
}

; CHECK-LABEL: test10
; CHECK: vcmpeqps
; CHECK: vblendmps
; CHECK: ret
define <8 x float> @test10(<8 x float> %x, <8 x float> %y) nounwind {
  %mask = fcmp oeq <8 x float> %x, %y
  %max = select <8 x i1> %mask, <8 x float> %x, <8 x float> %y
  ret <8 x float> %max
}

; CHECK-LABEL: test11_unsigned
; CHECK: vpcmpnleud %zmm
; CHECK: vpblendmd  %zmm
; CHECK: ret
define <8 x i32> @test11_unsigned(<8 x i32> %x, <8 x i32> %y) nounwind {
  %mask = icmp ugt <8 x i32> %x, %y
  %max = select <8 x i1> %mask, <8 x i32> %x, <8 x i32> %y
  ret <8 x i32> %max
}

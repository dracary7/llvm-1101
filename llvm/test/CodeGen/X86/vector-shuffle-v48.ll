; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+ssse3 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+xop  | FileCheck %s --check-prefixes=CHECK,XOP
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX2
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+avx512vl,+avx512bw | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512BW
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+avx512f,+avx512vl,+avx512vbmi | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512VBMI

define <32 x i8> @foo(<48 x i8>* %x0) {
; SSE-LABEL: foo:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqu (%rdi), %xmm0
; SSE-NEXT:    movdqu 16(%rdi), %xmm2
; SSE-NEXT:    movdqu 32(%rdi), %xmm1
; SSE-NEXT:    movdqa %xmm2, %xmm3
; SSE-NEXT:    pshufb {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,2,3,5,6]
; SSE-NEXT:    pshufb {{.*#+}} xmm0 = xmm0[0,1,3,4,6,7,9,10,12,13,15],zero,zero,zero,zero,zero
; SSE-NEXT:    por %xmm3, %xmm0
; SSE-NEXT:    pshufb {{.*#+}} xmm2 = xmm2[8,9,11,12,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; SSE-NEXT:    pshufb {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,xmm1[1,2,4,5,7,8,10,11,13,14]
; SSE-NEXT:    por %xmm2, %xmm1
; SSE-NEXT:    retq
;
; XOP-LABEL: foo:
; XOP:       # %bb.0:
; XOP-NEXT:    vmovdqu (%rdi), %xmm0
; XOP-NEXT:    vmovdqu 16(%rdi), %xmm1
; XOP-NEXT:    vmovdqu 32(%rdi), %xmm2
; XOP-NEXT:    vpshufb {{.*#+}} xmm3 = xmm1[8,9,11,12,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; XOP-NEXT:    vpshufb {{.*#+}} xmm2 = zero,zero,zero,zero,zero,zero,xmm2[1,2,4,5,7,8,10,11,13,14]
; XOP-NEXT:    vpor %xmm3, %xmm2, %xmm2
; XOP-NEXT:    vpshufb {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0,2,3,5,6]
; XOP-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,3,4,6,7,9,10,12,13,15],zero,zero,zero,zero,zero
; XOP-NEXT:    vpor %xmm1, %xmm0, %xmm0
; XOP-NEXT:    vinsertf128 $1, %xmm2, %ymm0, %ymm0
; XOP-NEXT:    retq
;
; AVX2-LABEL: foo:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqu 32(%rdi), %xmm0
; AVX2-NEXT:    vmovdqu (%rdi), %ymm1
; AVX2-NEXT:    vmovdqu 16(%rdi), %xmm2
; AVX2-NEXT:    vpshufb {{.*#+}} xmm2 = xmm2[u,u,u,u,u,u,u,u,u,u,u,0,2,3,5,6]
; AVX2-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[0,1,3,4,6,7,9,10,12,13,15,u,u,u,u,u,24,25,27,28,30,31,u,u,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm3 = <255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,255,255,255,255,255,255,u,u,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpblendvb %ymm3, %ymm1, %ymm2, %ymm1
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[u,u,u,u,u,u,1,2,4,5,7,8,10,11,13,14]
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm0
; AVX2-NEXT:    vpblendw {{.*#+}} ymm0 = ymm1[0,1,2],ymm0[3,4,5,6,7],ymm1[8,9,10],ymm0[11,12,13,14,15]
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = ymm1[0,1,2,3],ymm0[4,5,6,7]
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: foo:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovdqu (%rdi), %ymm0
; AVX512F-NEXT:    vmovdqu 32(%rdi), %xmm1
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm1 = xmm1[u,u,u,u,u,u,1,2,4,5,7,8,10,11,13,14]
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm1
; AVX512F-NEXT:    vmovdqu 16(%rdi), %xmm2
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm2 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,ymm2[0,2,3,5,6],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,3,4,6,7,9,10,12,13,15],zero,zero,zero,zero,zero,ymm0[24,25,27,28,30,31,u,u,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vpor %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpblendw {{.*#+}} ymm1 = ymm0[0,1,2],ymm1[3,4,5,6,7],ymm0[8,9,10],ymm1[11,12,13,14,15]
; AVX512F-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0,1,2,3],ymm1[4,5,6,7]
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: foo:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovdqu 32(%rdi), %xmm0
; AVX512BW-NEXT:    vmovdqu (%rdi), %ymm1
; AVX512BW-NEXT:    vmovdqu 16(%rdi), %xmm2
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm2 = xmm2[u,u,u,u,u,u,u,u,u,u,u,0,2,3,5,6]
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm1 = ymm1[0,1,3,4,6,7,9,10,12,13,15,u,u,u,u,u,24,25,27,28,30,31,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    movl $63488, %eax # imm = 0xF800
; AVX512BW-NEXT:    kmovd %eax, %k1
; AVX512BW-NEXT:    vmovdqu8 %ymm2, %ymm1 {%k1}
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[u,u,u,u,u,u,1,2,4,5,7,8,10,11,13,14]
; AVX512BW-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm2
; AVX512BW-NEXT:    vmovdqa {{.*#+}} ymm0 = [0,1,2,3,4,5,6,7,8,9,10,27,28,29,30,31]
; AVX512BW-NEXT:    vpermi2w %ymm2, %ymm1, %ymm0
; AVX512BW-NEXT:    retq
;
; AVX512VBMI-LABEL: foo:
; AVX512VBMI:       # %bb.0:
; AVX512VBMI-NEXT:    vmovdqu (%rdi), %ymm1
; AVX512VBMI-NEXT:    vmovdqu 32(%rdi), %xmm2
; AVX512VBMI-NEXT:    vmovdqa {{.*#+}} ymm0 = [0,1,3,4,6,7,9,10,12,13,15,16,18,19,21,22,24,25,27,28,30,31,33,34,36,37,39,40,42,43,45,46]
; AVX512VBMI-NEXT:    vpermi2b %ymm2, %ymm1, %ymm0
; AVX512VBMI-NEXT:    retq
  %1 = load <48 x i8>, <48 x i8>* %x0, align 1
  %2 = shufflevector <48 x i8> %1, <48 x i8> undef, <32 x i32> <i32 0, i32 1, i32 3, i32 4, i32 6, i32 7, i32 9, i32 10, i32 12, i32 13, i32 15, i32 16, i32 18, i32 19, i32 21, i32 22, i32 24, i32 25, i32 27, i32 28, i32 30, i32 31, i32 33, i32 34, i32 36, i32 37, i32 39, i32 40, i32 42, i32 43, i32 45, i32 46>
  ret <32 x i8> %2
}

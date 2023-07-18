	.text
	.file	"MicroJ"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3                               # -- Begin function main
.LCPI0_0:
	.quad	0x4010cccccccccccd              # double 4.2000000000000002
.LCPI0_1:
	.quad	0xbfb99999999999a0              # double -0.10000000000000009
.LCPI0_2:
	.quad	0x4011a3d70a3d70a4              # double 4.4100000000000001
.LCPI0_3:
	.quad	0x3ff0000000000000              # double 1
.LCPI0_4:
	.quad	0xc000cccccccccccd              # double -2.1000000000000001
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	leaq	.Lfmt(%rip), %rbx
	movl	$4, %esi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$4, %esi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movl	$1, %esi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	leaq	.Lfmt.1(%rip), %r14
	movsd	.LCPI0_0(%rip), %xmm0           # xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	printf@PLT
	movsd	.LCPI0_1(%rip), %xmm0           # xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	printf@PLT
	movsd	.LCPI0_2(%rip), %xmm0           # xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	printf@PLT
	movsd	.LCPI0_3(%rip), %xmm0           # xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	movsd	.LCPI0_4(%rip), %xmm0           # xmm0 = mem[0],zero
	movq	%r14, %rdi
	movb	$1, %al
	callq	printf@PLT
	movq	%rbx, %rdi
	movq	$-10, %rsi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.Lfmt,@object                   # @fmt
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lfmt:
	.asciz	"%d\n"
	.size	.Lfmt, 4

	.type	.Lfmt.1,@object                 # @fmt.1
.Lfmt.1:
	.asciz	"%f\n"
	.size	.Lfmt.1, 4

	.type	.Lfmt.2,@object                 # @fmt.2
.Lfmt.2:
	.asciz	"%s\n"
	.size	.Lfmt.2, 4

	.section	".note.GNU-stack","",@progbits

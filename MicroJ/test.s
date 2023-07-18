	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 13, 0
	.globl	_Animal                         ## -- Begin function Animal
	.p2align	4, 0x90
_Animal:                                ## @Animal
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$48, %edi
	callq	_malloc
	movq	%rax, _my_struct_ptr(%rip)
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movq	$0, 16(%rax)
	movq	$0, 24(%rax)
	movq	$0, 32(%rax)
	movq	$0, 40(%rax)
	popq	%rcx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_Animal.1                       ## -- Begin function Animal.1
	.p2align	4, 0x90
_Animal.1:                              ## @Animal.1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movl	$48, %edi
	callq	_malloc
	movq	%rax, _my_struct_ptr(%rip)
	movq	$0, (%rax)
	movq	$0, 16(%rax)
	movq	$0, 24(%rax)
	movq	$0, 32(%rax)
	movq	$0, 40(%rax)
	movq	%r14, 8(%rax)
	movq	%rbx, _offset(%rip)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_sum                            ## -- Begin function sum
	.p2align	4, 0x90
_sum:                                   ## @sum
	.cfi_startproc
## %bb.0:                               ## %entry
	movq	%rsi, %rax
	movq	%rdi, -8(%rsp)
	movq	%rsi, -16(%rsp)
	addq	_offset(%rip), %rax
	movq	%rax, -24(%rsp)
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bark                           ## -- Begin function bark
	.p2align	4, 0x90
_bark:                                  ## @bark
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	leaq	L_fmt.8(%rip), %rdi
	leaq	L_str(%rip), %rsi
	xorl	%eax, %eax
	callq	_printf
	popq	%rax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bark1                          ## -- Begin function bark1
	.p2align	4, 0x90
_bark1:                                 ## @bark1
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	L_fmt.14(%rip), %rdi
	leaq	L_str.15(%rip), %rsi
	xorl	%eax, %eax
	callq	_printf
	popq	%rax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_Cat                            ## -- Begin function Cat
	.p2align	4, 0x90
_Cat:                                   ## @Cat
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$48, %edi
	callq	_malloc
	movq	%rax, _my_struct_ptr.3(%rip)
	movq	$0, (%rax)
	movq	$0, 8(%rax)
	movq	$0, 16(%rax)
	movq	$0, 24(%rax)
	movq	$0, 32(%rax)
	movq	$0, 40(%rax)
	popq	%rcx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bark.2                         ## -- Begin function bark.2
	.p2align	4, 0x90
_bark.2:                                ## @bark.2
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	leaq	L_fmt.18(%rip), %rdi
	leaq	L_str.19(%rip), %rsi
	xorl	%eax, %eax
	callq	_printf
	popq	%rax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_class_name                     ## -- Begin function class_name
	.p2align	4, 0x90
_class_name:                            ## @class_name
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	leaq	L_fmt.22(%rip), %rdi
	leaq	L_str.23(%rip), %rsi
	xorl	%eax, %eax
	callq	_printf
	popq	%rax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_eat                            ## -- Begin function eat
	.p2align	4, 0x90
_eat:                                   ## @eat
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movq	%rdi, (%rsp)
	leaq	L_fmt.26(%rip), %rdi
	leaq	L_str.27(%rip), %rsi
	xorl	%eax, %eax
	callq	_printf
	popq	%rax
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_num                            ## -- Begin function num
	.p2align	4, 0x90
_num:                                   ## @num
	.cfi_startproc
## %bb.0:                               ## %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rdi, 16(%rsp)
	movq	%rsi, 8(%rsp)
	leaq	L_fmt.28(%rip), %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	8(%rsp), %rax
	addq	$2, %rax
	addq	$24, %rsp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:                               ## %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$64, %rsp
	.cfi_def_cfa_offset 80
	.cfi_offset %rbx, -16
	movl	$87, %edi
	movl	$100, %esi
	callq	_Animal.1
	movq	%rax, (%rsp)
	callq	_Animal
	movq	%rax, 8(%rsp)
	callq	_Cat
	movq	%rax, 56(%rsp)
	movq	%rax, %rdi
	callq	_bark.2
	movq	(%rsp), %rax
	movsd	40(%rax), %xmm0                 ## xmm0 = mem[0],zero
	leaq	L_fmt.4(%rip), %rdi
	movb	$1, %al
	callq	_printf
	movq	(%rsp), %rax
	movq	(%rax), %rsi
	leaq	L_fmt(%rip), %rbx
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	_f1(%rip), %rsi
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	_printf
	movq	(%rsp), %rdi
	movl	$2, %esi
	callq	_sum
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	_printf
	movq	(%rsp), %rax
	movq	%rax, 48(%rsp)
	movq	%rbx, %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	_printf
	movq	(%rsp), %rax
	xorl	%esi, %esi
	cmpq	8(%rsp), %rax
	sete	%sil
	movq	%rbx, %rdi
	xorl	%eax, %eax
	callq	_printf
	callq	_bark1
	movq	(%rsp), %rdi
	callq	_bark
	movq	(%rsp), %rax
	movq	$198, 8(%rax)
	movq	(%rsp), %rdi
	movl	$3, %esi
	callq	_sum
	movq	%rax, 40(%rsp)
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	_printf
	movq	8(%rsp), %rax
	movq	$34, 8(%rax)
	movq	8(%rsp), %rdi
	movl	$4, %esi
	callq	_sum
	movq	%rax, 32(%rsp)
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%eax, %eax
	callq	_printf
	callq	_bark1
	movl	$24, %edi
	callq	_malloc
	movq	%rax, 16(%rsp)
	movq	(%rsp), %rcx
	movq	%rcx, 8(%rax)
	movq	16(%rsp), %rax
	movq	8(%rax), %rdi
	movq	%rdi, 24(%rsp)
	callq	_bark
	xorl	%eax, %eax
	addq	$64, %rsp
	popq	%rbx
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_offset                         ## @offset
.zerofill __DATA,__common,_offset,8,3
	.globl	_f1                             ## @f1
.zerofill __DATA,__common,_f1,8,3
	.globl	_f2                             ## @f2
.zerofill __DATA,__common,_f2,8,3
	.globl	_my_struct_ptr                  ## @my_struct_ptr
.zerofill __DATA,__common,_my_struct_ptr,8,3
	.globl	_my_struct_ptr.3                ## @my_struct_ptr.3
.zerofill __DATA,__common,_my_struct_ptr.3,8,3
	.section	__TEXT,__cstring,cstring_literals
L_fmt:                                  ## @fmt
	.asciz	"%d\n"

L_fmt.4:                                ## @fmt.4
	.asciz	"%f\n"

L_fmt.5:                                ## @fmt.5
	.asciz	"%s\n"

L_fmt.6:                                ## @fmt.6
	.asciz	"%d\n"

L_fmt.7:                                ## @fmt.7
	.asciz	"%f\n"

L_fmt.8:                                ## @fmt.8
	.asciz	"%s\n"

L_str:                                  ## @str
	.asciz	"\"Nonstatic Animal bark\""

L_fmt.9:                                ## @fmt.9
	.asciz	"%d\n"

L_fmt.10:                               ## @fmt.10
	.asciz	"%f\n"

L_fmt.11:                               ## @fmt.11
	.asciz	"%s\n"

L_fmt.12:                               ## @fmt.12
	.asciz	"%d\n"

L_fmt.13:                               ## @fmt.13
	.asciz	"%f\n"

L_fmt.14:                               ## @fmt.14
	.asciz	"%s\n"

L_str.15:                               ## @str.15
	.asciz	"\"Static Animal bark\""

L_fmt.16:                               ## @fmt.16
	.asciz	"%d\n"

L_fmt.17:                               ## @fmt.17
	.asciz	"%f\n"

L_fmt.18:                               ## @fmt.18
	.asciz	"%s\n"

L_str.19:                               ## @str.19
	.asciz	"\"Cat miao\""

L_fmt.20:                               ## @fmt.20
	.asciz	"%d\n"

L_fmt.21:                               ## @fmt.21
	.asciz	"%f\n"

L_fmt.22:                               ## @fmt.22
	.asciz	"%s\n"

L_str.23:                               ## @str.23
	.asciz	"\"My class is Cat\""

L_fmt.24:                               ## @fmt.24
	.asciz	"%d\n"

L_fmt.25:                               ## @fmt.25
	.asciz	"%f\n"

L_fmt.26:                               ## @fmt.26
	.asciz	"%s\n"

L_str.27:                               ## @str.27
	.asciz	"\"Cats eat fish\""

L_fmt.28:                               ## @fmt.28
	.asciz	"%d\n"

L_fmt.29:                               ## @fmt.29
	.asciz	"%f\n"

L_fmt.30:                               ## @fmt.30
	.asciz	"%s\n"

.subsections_via_symbols

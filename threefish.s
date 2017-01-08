	.file	"threefish.c"
	.intel_syntax noprefix
	.text
	.globl	_threefish_setkey
	.def	_threefish_setkey;	.scl	2;	.type	32;	.endef
_threefish_setkey:
LFB18:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ecx, 8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	mov	edx, DWORD PTR [ebp+8]
	push	edi
	push	esi
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	mov	esi, DWORD PTR [ebp+12]
	push	ebx
	.cfi_offset 3, -20
	mov	ebx, DWORD PTR [ebp+16]
	mov	edi, edx
	rep movsd
	lea	eax, [edx+64]
	mov	edi, eax
	mov	esi, ebx
	mov	cl, 4
	rep movsd
	mov	eax, DWORD PTR [ebx+8]
	xor	eax, DWORD PTR [ebx]
	mov	DWORD PTR [edx+80], eax
	mov	eax, DWORD PTR [ebx+12]
	xor	eax, DWORD PTR [ebx+4]
	mov	DWORD PTR [edx+32], -1443096030
	mov	DWORD PTR [edx+36], 466688986
	mov	DWORD PTR [edx+84], eax
	xor	eax, eax
L3:
	mov	esi, DWORD PTR [ebp+12]
	mov	ecx, DWORD PTR [esi+eax]
	xor	DWORD PTR [edx+32], ecx
	mov	ecx, DWORD PTR [esi+4+eax]
	add	eax, 8
	xor	DWORD PTR [edx+36], ecx
	cmp	eax, 32
	jne	L3
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE18:
	.globl	_mix
	.def	_mix;	.scl	2;	.type	32;	.endef
_mix:
LFB19:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	edi
	push	esi
	push	ebx
	sub	esp, 28
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	mov	eax, DWORD PTR [ebp+8]
	and	DWORD PTR [ebp+16], 7
	mov	DWORD PTR [ebp-20], 0
	lea	ebx, [eax+8]
L10:
	mov	eax, DWORD PTR [ebp-20]
	mov	edx, DWORD PTR [ebp+16]
	add	eax, DWORD PTR [ebp+12]
	cmp	DWORD PTR [ebp+20], 1
	mov	cl, BYTE PTR [eax+edx]
	jne	L7
	mov	eax, DWORD PTR [ebx-8]
	xor	eax, DWORD PTR [ebx]
	mov	DWORD PTR [ebp-40], 64
	mov	DWORD PTR [ebp-32], eax
	mov	eax, DWORD PTR [ebx-4]
	xor	eax, DWORD PTR [ebx+4]
	mov	esi, DWORD PTR [ebp-32]
	mov	DWORD PTR [ebp-28], eax
	mov	edi, DWORD PTR [ebp-28]
	xor	eax, eax
	mov	edx, DWORD PTR [ebp-28]
	shrd	esi, edi, cl
	shr	edi, cl
	test	cl, 32
	cmovne	esi, edi
	cmovne	edi, eax
	mov	al, BYTE PTR [ebp-40]
	sub	eax, ecx
	mov	cl, al
	mov	eax, DWORD PTR [ebp-32]
	shld	edx, eax, cl
	sal	eax, cl
	test	cl, 32
	je	L13
	mov	edx, eax
	xor	eax, eax
L13:
	mov	ecx, eax
	mov	eax, edx
	or	eax, edi
	or	ecx, esi
	mov	esi, eax
	sub	DWORD PTR [ebx-8], ecx
	sbb	DWORD PTR [ebx-4], esi
	mov	DWORD PTR [ebx], ecx
	mov	DWORD PTR [ebx+4], esi
	jmp	L8
L7:
	mov	eax, DWORD PTR [ebx]
	mov	edx, DWORD PTR [ebx+4]
	add	DWORD PTR [ebx-8], eax
	adc	DWORD PTR [ebx-4], edx
	mov	esi, eax
	mov	edi, edx
	shld	edi, eax, cl
	sal	esi, cl
	mov	DWORD PTR [ebp-40], eax
	xor	eax, eax
	test	cl, 32
	cmovne	edi, esi
	cmovne	esi, eax
	mov	DWORD PTR [ebp-24], 64
	mov	al, BYTE PTR [ebp-24]
	mov	DWORD PTR [ebp-36], edx
	mov	edx, DWORD PTR [ebp-36]
	sub	eax, ecx
	mov	cl, al
	mov	eax, DWORD PTR [ebp-40]
	shrd	eax, edx, cl
	shr	edx, cl
	test	cl, 32
	je	L12
	mov	eax, edx
	xor	edx, edx
L12:
	or	eax, esi
	or	edx, edi
	xor	eax, DWORD PTR [ebx-8]
	xor	edx, DWORD PTR [ebx-4]
	mov	DWORD PTR [ebx], eax
	mov	DWORD PTR [ebx+4], edx
L8:
	add	DWORD PTR [ebp-20], 8
	add	ebx, 16
	cmp	DWORD PTR [ebp-20], 16
	jne	L10
	add	esp, 28
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE19:
	.globl	_permute
	.def	_permute;	.scl	2;	.type	32;	.endef
_permute:
LFB20:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	esi
	.cfi_offset 6, -12
	mov	esi, DWORD PTR [ebp+8]
	push	ebx
	.cfi_offset 3, -16
	mov	ebx, DWORD PTR [esi+12]
	mov	ecx, DWORD PTR [esi+8]
	mov	eax, DWORD PTR [esi+24]
	mov	edx, DWORD PTR [esi+28]
	mov	DWORD PTR [esi+28], ebx
	mov	DWORD PTR [esi+24], ecx
	mov	DWORD PTR [esi+8], eax
	mov	DWORD PTR [esi+12], edx
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE20:
	.globl	_addkey
	.def	_addkey;	.scl	2;	.type	32;	.endef
_addkey:
LFB21:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	edi
	push	esi
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	mov	esi, 3
	push	ebx
	sub	esp, 60
	.cfi_offset 3, -20
	mov	ebx, DWORD PTR [ebp+16]
	mov	eax, DWORD PTR [ebp+20]
	mov	edx, DWORD PTR [ebp+24]
	mov	edi, DWORD PTR [ebp+12]
	movzx	ecx, bl
	mov	DWORD PTR [ebp-24], eax
	movzx	eax, bl
	mov	DWORD PTR [ebp-20], edx
	mov	dl, 3
	div	dl
	mov	DWORD PTR [ebp-60], ecx
	mov	DWORD PTR [ebp-72], ecx
	mov	DWORD PTR [ebp-68], 0
	movzx	eax, ah
	mov	DWORD PTR [ebp-44], eax
	lea	eax, [ecx+1]
	cdq
	idiv	esi
	xor	si, si
	neg	DWORD PTR [ebp-24]
	adc	DWORD PTR [ebp-20], 0
	neg	DWORD PTR [ebp-20]
	mov	DWORD PTR [ebp-48], edx
L21:
	mov	eax, DWORD PTR [edi+esi*8]
	mov	ecx, 5
	mov	DWORD PTR [ebp-52], eax
	mov	eax, DWORD PTR [edi+4+esi*8]
	mov	DWORD PTR [ebp-56], eax
	mov	eax, DWORD PTR [ebp-60]
	add	eax, esi
	cdq
	idiv	ecx
	mov	eax, DWORD PTR [ebp+8]
	cmp	esi, 1
	lea	edx, [eax+edx*8]
	mov	eax, DWORD PTR [edx]
	mov	edx, DWORD PTR [edx+4]
	mov	DWORD PTR [ebp-40], eax
	mov	DWORD PTR [ebp-36], edx
	jne	L17
	mov	eax, DWORD PTR [ebp+8]
	mov	edx, DWORD PTR [ebp-44]
	mov	ecx, DWORD PTR [eax+64+edx*8]
	mov	ebx, DWORD PTR [eax+68+edx*8]
	jmp	L18
L17:
	cmp	esi, 2
	jne	L19
	mov	eax, DWORD PTR [ebp+8]
	mov	ebx, DWORD PTR [ebp-48]
	mov	ecx, DWORD PTR [eax+64+ebx*8]
	mov	ebx, DWORD PTR [eax+68+ebx*8]
	jmp	L18
L19:
	xor	ecx, ecx
	xor	ebx, ebx
	cmp	esi, 3
	jne	L18
	mov	ecx, DWORD PTR [ebp-72]
	mov	ebx, DWORD PTR [ebp-68]
L18:
	mov	eax, DWORD PTR [ebp-52]
	xor	eax, DWORD PTR [ebp-24]
	mov	edx, DWORD PTR [ebp-36]
	mov	DWORD PTR [ebp-32], eax
	mov	eax, DWORD PTR [ebp-56]
	xor	eax, DWORD PTR [ebp-20]
	mov	DWORD PTR [ebp-28], eax
	mov	eax, DWORD PTR [ebp-40]
	add	eax, DWORD PTR [ebp-32]
	adc	edx, DWORD PTR [ebp-28]
	add	eax, ecx
	mov	ecx, DWORD PTR [ebp-24]
	adc	edx, ebx
	mov	ebx, DWORD PTR [ebp-20]
	xor	eax, ecx
	mov	DWORD PTR [edi+esi*8], eax
	mov	eax, edx
	xor	eax, ebx
	mov	DWORD PTR [edi+4+esi*8], eax
	inc	esi
	cmp	esi, 4
	jne	L21
	add	esp, 60
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE21:
	.data
	.align 4
LC0:
	.byte	14
	.byte	52
	.byte	23
	.byte	5
	.byte	25
	.byte	46
	.byte	58
	.byte	32
	.byte	16
	.byte	57
	.byte	40
	.byte	37
	.byte	33
	.byte	12
	.byte	22
	.byte	32
	.text
	.globl	_threefish_encrypt
	.def	_threefish_encrypt;	.scl	2;	.type	32;	.endef
_threefish_encrypt:
LFB22:
	.cfi_startproc
	push	ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	mov	ecx, 4
	mov	ebp, esp
	.cfi_def_cfa_register 5
	push	edi
	push	esi
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	mov	esi, OFFSET FLAT:LC0
	push	ebx
	sub	esp, 60
	.cfi_offset 3, -20
	mov	ebx, DWORD PTR [ebp+12]
	cmp	DWORD PTR [ebp+16], 1
	lea	edi, [ebp-32]
	rep movsd
	jne	L31
	mov	eax, DWORD PTR [ebp-32]
	mov	esi, -1
	mov	edx, DWORD PTR [ebp-28]
	mov	BYTE PTR [ebp-33], 18
	bswap	eax
	mov	DWORD PTR [ebp-28], eax
	mov	eax, DWORD PTR [ebp-24]
	bswap	edx
	mov	DWORD PTR [ebp-32], edx
	mov	edx, DWORD PTR [ebp-20]
	bswap	eax
	mov	DWORD PTR [ebp-20], eax
	bswap	edx
	mov	DWORD PTR [ebp-24], edx
	jmp	L25
L31:
	mov	esi, 1
	mov	BYTE PTR [ebp-33], 0
L25:
	mov	eax, DWORD PTR [ebp+16]
	xor	edx, edx
	xor	edi, edi
	mov	DWORD PTR [ebp-44], edx
	mov	DWORD PTR [ebp-48], eax
L30:
	test	edi, 3
	jne	L26
	mov	eax, DWORD PTR [ebp-48]
	mov	edx, DWORD PTR [ebp-44]
	mov	DWORD PTR [esp+4], ebx
	mov	DWORD PTR [esp+12], eax
	movzx	eax, BYTE PTR [ebp-33]
	mov	DWORD PTR [esp+16], edx
	mov	DWORD PTR [esp+8], eax
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [esp], eax
	call	_addkey
	mov	eax, esi
	add	BYTE PTR [ebp-33], al
L26:
	cmp	DWORD PTR [ebp+16], 1
	jne	L27
	mov	DWORD PTR [esp], ebx
	call	_permute
L27:
	mov	eax, DWORD PTR [ebp+16]
	mov	DWORD PTR [esp+8], edi
	mov	DWORD PTR [esp], ebx
	mov	DWORD PTR [esp+12], eax
	lea	eax, [ebp-32]
	mov	DWORD PTR [esp+4], eax
	call	_mix
	cmp	DWORD PTR [ebp+16], 0
	jne	L28
	mov	DWORD PTR [esp], ebx
	call	_permute
L28:
	inc	edi
	cmp	edi, 72
	jne	L30
	mov	eax, DWORD PTR [ebp+16]
	movzx	esi, BYTE PTR [ebp-33]
	mov	DWORD PTR [esp+4], ebx
	mov	DWORD PTR [esp+16], 0
	mov	DWORD PTR [esp+12], eax
	mov	eax, DWORD PTR [ebp+8]
	mov	DWORD PTR [esp+8], esi
	mov	DWORD PTR [esp], eax
	call	_addkey
	add	esp, 60
	pop	ebx
	.cfi_restore 3
	pop	esi
	.cfi_restore 6
	pop	edi
	.cfi_restore 7
	pop	ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
LFE22:
	.ident	"GCC: (GNU) 4.8.1"

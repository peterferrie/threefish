;
;  Copyright © 2015 Odzhan, Peter Ferrie.
;
;  All Rights Reserved.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions are
;  met:
;
;  1. Redistributions of source code must retain the above copyright
;  notice, this list of conditions and the following disclaimer.
;
;  2. Redistributions in binary form must reproduce the above copyright
;  notice, this list of conditions and the following disclaimer in the
;  documentation and/or other materials provided with the distribution.
;
;  3. The name of the author may not be used to endorse or promote products
;  derived from this software without specific prior written permission.
;
;  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
;  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
;  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.

; -----------------------------------------------
; Threefish-256 block cipher in x86 assembly
;
; size: 350 bytes
;
; global calls use cdecl convention
;
; -----------------------------------------------

    bits 32

%define t0 mm0
%define t1 mm1
    
%define x0 mm0
%define x1 mm1
%define x2 mm2
%define x3 mm3
%define x4 mm4
%define x5 mm5
%define x6 mm6
%define x7 mm7
    
%define r eax
    
threefish_setkey:
    pushad
    lea    esi, [esp+32+4]
    lodsd
    
    push   0x1BD11BDA
    push   0xA9FC1A22
    movq   x4, [esp]
    pop    eax
    pop    eax
    
    ; memcpy((void*)c->k, key,   32);
    push   8
    pop    ecx
    rep    movsd
    
    ; memcpy((void*)c->t, tweak, 16);
    mov    cl, 4
    rep    movsd
tf_sk:
    pxor   x4, [esi+8*ecx]
    inc    ecx
    cmp    cl, 4
    jnz    tf_sk
    
    pxor   t0, t1
    movq   [ebx+2*8], t0
    popad
    ret

rotl64:
    movq   x6, x1
    movd   x7, eax
    psllq  x6, x7
    psrlq  x1, x7
    por    x1, x6
    ret
    
; void mix(
;    void *data, 
;    uint8_t rc[], 
;    int rnd, int enc)
mix:
    pushad
    xor    eax, eax
    cdq
m_l0:    
    movq   x0, [esi+edx*8]
    movq   x1, [esi+edx*8]
    
    ; r = rc[(rnd & 7) + (i << 2)];
    mov    edx, eax
    movzx  r, byte[ebx+eax]
    jecxz  m_l1
    
    sub    r, 64
    neg    r
    
    pxor   x1, x0
    call   rotl64
    psubq  x0, x1
    jmp    m_l2
m_l1    
    paddq  x0, x1
    call   rotl64
    pxor   x1, x0
m_l2:
    movq   [esi+edx*8  ], x0    
    movq   [esi+edx*8+8], x1    
    add    dl, 2
    cmp    dl, 4
    jnz    m_l0
    popad
    ret
    
; void permute(void *data)    
permute:
    movq   x0, [esi+1*8]
    movq   x1, [esi+3*8]

    movq   [esi+1*8], x1 
    movq   [esi+3*8], x0 
    ret
    
; void addkey(const threefish_ctx_t *c, 
;    void *data, uint8_t s, 
;    uint64_t enc)
addkey:
    pushad
    pxor    x3, x3           ; x3 = 0 
    jecxz   ak_l0
    
    pcmpeqb x3, x3           ; x3 = ~0
    dec     ecx
ak_l0:  
    push    5
    pop     ebp  
    
    ; x0 = x[i];
    movq    x0, [esi+ecx*8]   
    
    ; x1 = c->k[(s + i) % 5];
    lea     eax, [edi+ecx]    
    cdq    
    idiv    ebp        
    movq    x1, [ebx+edx*8]
    
    ; x2 = 0;
    pxor    x2, x2
    
    dec     ebp
    dec     ebp    
    
    ; if (i==1) x2 = c->t[s % 3];
    mov     eax, edi
    cdq
    idiv    ebp
    movq    x2, [ebx+edx*8]
    
    ; if (i==2) x2 = c->t[(s+1) % 3];
    mov     eax, edi
    inc     eax
    cdq
    idiv    ebp
    movq    x2, [ebx+edx*8]

    ; if (i==3) x2 = s;
    movd    x2, edi
    
    pxor    x0, x3
    paddq   x0, x1
    paddq   x0, x2
    pxor    x0, x3
    movq    [esi+ecx*8], x0
    
    inc     ecx
    cmp     cl, 4
    jnz     ak_l0    
    popad
    ret
    
; void threefish_encrypt(
;    const threefish_ctx_t *c, 
;    void *data, 
;    uint32_t enc)
threefish_encrypt:
    pushad
    lea    esi, [esp+32+4]
    lodsd
    xchg   ebx, eax    
    lodsd
    push   eax
    lodsd
    cdq
    xchg   eax, ecx
    pop    esi
    jecxz  tf_l1
    neg    ebp               ; evp = -1
    pushad
    ;mov    esi, [esp+_esp]
    mov    edi, esi
tf_l0:    
    lodsd
    xchg   eax, ebx
    lodsd
    bswap  eax
    stosd
    xchg   eax, ebx
    bswap  eax
    stosd
    dec    edx
    jnp    tf_l0
    popad
    ; apply 72 rounds
tf_l1:    
    ; add key every 4 rounds
    test  dl, 3
    jnz   tf_l2
    call  addkey
    add   edi, ebp
tf_l2:    
    ; permute if decrypting
    jecxz tf_l3    
    call  permute 
tf_l3:    
    ; apply mixing function
    call  mix
    ; permute if encrypting
    test  ecx, ecx
    jz    tf_l4
    call  permute
tf_l4:    
    inc   eax                 
    cmp   al, 72
    jnz   tf_l1 
    ; add key
    call  addkey
    popad
    ret

    
    
    
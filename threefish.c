/**
  Copyright © 2017 Odzhan. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */


#include <stdint.h>
#include <string.h>

#include "threefish.h"

// without shift functions, 32-bit compiler uses
// external assembly functions
uint64_t shl64 (uint64_t v, uint32_t n)
{
  union {
    uint32_t v32[2];
    uint64_t v64;
  } r, t;
  
  r.v64 = 0;
  
  if (n<64) {
    t.v64 = v;
    if (n==0) {
      r.v64 = t.v64;
    } else if (n<32) {
      r.v32[0]  =  t.v32[0] << n; // shift low bits left by n
      r.v32[1]  =  t.v32[1] << n; // shift upper bits left by n
      r.v32[1] |= (t.v32[0] >> (32 - n));
    } else {
      r.v32[0]  = 0;
      r.v32[1]  = (t.v32[0] << (n & 31));
    }
  }
  return r.v64;
}

uint64_t shr64 (uint64_t v, uint32_t n)
{
  union {
    uint32_t v32[2];
    uint64_t v64;
  } r, t;
  
  r.v64 = 0;
  
  if (n<64) {
    t.v64 = v;
    if (n==0) {
      r.v64 = t.v64;
    } else if (n<32) {
      r.v32[0]  =  t.v32[0] >> n; // shift low bits right by n
      r.v32[1]  =  t.v32[1] >> n; // shift upper bits right by n
      r.v32[0] |= (t.v32[1] << (32 - n));
    } else {
      r.v32[1]  = 0;
      r.v32[0]  = (t.v32[1] >> (n & 31));
    }
  }
  return r.v64;
}

uint64_t XROTL64 (uint64_t v, uint32_t n) 
{
  return shl64(v, n) | shr64(v, (64 - n));
}

uint64_t XROTR64 (uint64_t v, uint32_t n) 
{
  return shr64(v, n) | shl64(v, (64 - n));
}

#define THREEFISH_KEY_CONST 0x1BD11BDAA9FC1A22LL

#define K(s) (((uint64_t*)key)[(s)])
#define T(s) (((uint64_t*)tweak)[(s)])

#define B0 (((uint64_t*)data)[0])
#define B1 (((uint64_t*)data)[1])

void threefish_mix(void *data, uint8_t rot, int enc){
	uint64_t x;
  
  if (enc==THREEFISH_ENCRYPT)
  {
    B0 += B1;
    B1 = XROTL64(B1, rot) ^ B0;
  } else {
    B1 ^= B0;
    B1 = XROTR64(B1, rot);
    B0 -= B1;    
  }
}

void threefish_setkey(
    threefish_ctx_t *ctx,
    const void *key, 
    const void *tweak)
{
  uint8_t i;
  
	memcpy(ctx->k, key,   4*8);
  memcpy(ctx->t, tweak, 2*8);
	
  ctx->t[2] = T(0) ^ T(1);
	
	ctx->k[4] = THREEFISH_KEY_CONST;
  
	for(i=0; i<4; ++i){
		ctx->k[4] ^= K(i);
	}
}

#define X(a) (((uint64_t*)data)[(a)])

void permute_4(void *data){
	uint64_t t;
	t = X(1);
	X(1) = X(3);
	X(3) = t;
}

// perform both addition and subtraction 
// flag should be 0 for addition or 1 for subtraction
#define ADDSUB(x, y, z, flag) \
  ((x ^ -flag) + y + z) ^ -flag; \

void add_key_4(void *data, const threefish_ctx_t *ctx, uint8_t s, uint64_t enc){
  X(0) = ADDSUB(X(0), ctx->k[(s+0)%5], 0,               enc);
	X(1) = ADDSUB(X(1), ctx->k[(s+1)%5], ctx->t[s%3],     enc);
	X(2) = ADDSUB(X(2), ctx->k[(s+2)%5], ctx->t[(s+1)%3], enc);
	X(3) = ADDSUB(X(3), ctx->k[(s+3)%5], s,               enc);
}

void threefish_encrypt(const threefish_ctx_t *ctx, void *data, uint32_t enc)
{
	uint8_t i=0,s=0, ofs=1;
  uint32_t x0, x1;
  
	uint8_t r0[8] = {14, 52, 23,  5, 25, 46, 58, 32};
	uint8_t r1[8] = {16, 57, 40, 37, 33, 12, 22, 32};
  
  if (enc == THREEFISH_DECRYPT) {
    s = 18;
    ofs = -1;
    
    // r0
    x0 = ((uint32_t*)r0)[0];
    x1 = ((uint32_t*)r0)[1];
    
    ((uint32_t*)r0)[1] = _byteswap_ulong(x0);
    ((uint32_t*)r0)[0] = _byteswap_ulong(x1);
    
    // r1
    x0 = ((uint32_t*)r1)[0];
    x1 = ((uint32_t*)r1)[1];
    
    ((uint32_t*)r1)[1] = _byteswap_ulong(x0);
    ((uint32_t*)r1)[0] = _byteswap_ulong(x1);  
  }
  i=0;
	do{
		if(i % 4 == 0) {
			add_key_4(data, ctx, s, enc);
			s += ofs;
		}
    if (enc==THREEFISH_DECRYPT) {
      permute_4(data);
    }
		
    threefish_mix(data, r0[i%8], enc);
		threefish_mix((uint8_t*)data + 16, r1[i%8], enc);
    
    if (enc==THREEFISH_ENCRYPT) {
		  permute_4(data);
    }
		++i;
	}while(i!=72);
	add_key_4(data, ctx, s, enc);
}


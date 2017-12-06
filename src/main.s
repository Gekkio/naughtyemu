; Copyright (C) 2015-2017 Joonas Javanainen <joonas.javanainen@gmail.com>
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

.include "config.i"
.include "hardware.i"

.macro wait_ly ARGS value
_wait_ly_\@:
  ldh a, (<LY)
  cp value
  jr nz, _wait_ly_\@
.endm

.macro wait_vblank
  ; wait for LY=143 first to ensure we get a fresh v-blank
  wait_ly $89
  ; wait for LY=144
  wait_ly $90
.endm

.org $0150
main:
  wait_vblank

  xor a
  ldh (<LCDC), a
  ld bc, $0000
  ld de, $0000
  ld hl, $0000
  ld sp, $ffff

  call reset_screen

  ld a, %01010100
  ldh (<BGP), a

  call load_font

  call fill_bg
  call clear_oam

  ; Copy data to OAM
  ld hl, OAM
  ld de, data
  ld bc, data_end - data
  call memcpy

  ; Copy dma_proc to $ff80
  ld hl, hram.dma_proc
  ld de, dma_proc
  ld bc, _sizeof_dma_proc
  call memcpy

  ld a, %10010011
  ldh (<LCDC), a

  ei
  ld a, INTR_VBLANK | INTR_TIMER
  ldh (<IE), a

  ld a, 185
  ldh (<TMA), a
  ld a, 185
  ldh (<TIMA), a

- halt
  nop
  jr -

fill_bg:
  ld hl, $8000 + $80 * 16
  ld bc, 16
  ld a, $FF
  jp memset

dma_proc:
  ld a, %00000110
  ldh (<TAC), a
  ld a, $20
  ldh (<DMA), a

  nop

  halt
  nop

  ld a, 40
- dec a
  jr nz, -
  ret
dma_proc_end:

.org $2000
data:
  .db $FF $FF $40 $40
  .db $9F $A7 $9F $A7
  .db $20 $20 'N' $00
  .db $20 $28 'a' $00
  .db $20 $30 'u' $00
  .db $20 $38 'g' $00
  .db $20 $40 'h' $00
  .db $20 $48 't' $00
  .db $20 $50 'y' $00

  .db $40 $30 'e' $00
  .db $40 $38 'm' $00
  .db $40 $40 'u' $00
  .db $40 $48 'l' $00
  .db $40 $50 'a' $00
  .db $40 $58 't' $00
  .db $40 $60 'o' $00
  .db $40 $68 'r' $00
  .db $40 $70 '!' $00

  .db $60 $40 'N' $00
  .db $60 $48 'o' $00

  .db $60 $58 'p' $00
  .db $60 $60 'r' $00
  .db $60 $68 'e' $00
  .db $60 $70 's' $00
  .db $60 $78 'e' $00
  .db $60 $80 'n' $00
  .db $60 $88 't' $00
  .db $60 $90 's' $00

  .db $80 $50 'f' $00
  .db $80 $58 'o' $00
  .db $80 $60 'r' $00

  .db $80 $70 'y' $00
  .db $80 $78 'o' $00
  .db $80 $80 'u' $00
  .db $80 $88 '!' $00
data_end:

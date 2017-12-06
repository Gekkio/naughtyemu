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

.include "config.s"
.include "hardware.s"

.bank 1 slot 1
.section "Runtime" free

; Inputs:
;   BC: byte count
;   DE: source address
;   HL: target address
; Outputs: -
; Preserved: -
memcpy:
- ld a, (de)
  ld (hl+), a
  inc de
  dec bc
  ld a,b
  or c
  jr nz, -
  ret

; Inputs:
;   A: value
;   BC: byte count
;   HL: target
; Outputs: -
; Preserved: E
memset:
  ld d, a
- ld a, d
  ld (hl+), a
  dec bc
  ld a, b
  or c
  jr nz, -
  ret

; Inputs: -
; Outputs: -
; Preserved: E
clear_vram:
  ld hl, VRAM
  ld bc, $2000
  xor a
  jr memset

; Inputs: -
; Outputs: -
; Preserved: E
clear_oam:
  ld hl, OAM
  ld bc, $a0
  xor a
  jr memset

; Inputs: -
; Outputs: -
; Preserved: E
reset_screen:
  xor a
  ldh (<SCY), a
  ldh (<SCX), a
  ld a, $FC
  ldh (<BGP), a

  call clear_vram
  jr clear_oam

load_font:
  ld hl, VRAM + $10
  ld de, font
  ld bc, FONT_SIZE
  jr memcpy

.ends

.bank 1 slot 1
.section "Font" free
font:
  ; 8x8 ASCII bitmap font by Darkrose
  ; http://opengameart.org/content/8x8-ascii-bitmap-font-with-c-source
  .incbin "font.bin" fsize FONT_SIZE
.ends

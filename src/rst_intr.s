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

.bank 0 slot 0

.org INTR_VEC_TIMER
  jp timer_intr_handler

.org INTR_VEC_VBLANK
  jp vblank_intr_handler

.org INTR_VEC_STAT
  jp stat_intr_handler

.bank 0 slot 0
.section "Interrupts" free

timer_intr_handler:
  ldh a, (<BGP)
  cpl
  ldh (<BGP), a
  xor a
  ldh (<TAC), a
.repeat 38
  nop
.endr
  ld a, $F2
  ldh (<TIMA), a
  ld a, %00000111
  ldh (<TAC), a
  reti

stat_intr_handler:
  ldh a, (<hram.stat_toggle)
  cpl
  ldh (<hram.stat_toggle), a
  jr z, +

  ld a, %00001000
  ldh (<STAT), a
  reti

+ ldh a, (<SCX)
  add 5
  ldh (<SCX), a

  xor a
  ldh (<IF), a
  ld a, 185
  ldh (<TIMA), a
  call hram.dma_proc
  xor a
  ldh (<TAC), a

  ldh a, (<hram.stat_count)
  dec a
  ldh (<hram.stat_count), a
  jr z, +

  ldh a, (<LYC)
  add 32
  ldh (<LYC), a
  ld a, %01000000
  ldh (<STAT), a
  xor a
  ldh (<IF), a
  reti

+ xor a
  ldh (<STAT), a
  ld a, INTR_VBLANK | INTR_TIMER
  ldh (<IE), a
  xor a
  ldh (<IF), a
  reti

vblank_intr_handler:
  xor a
  ldh (<hram.stat_toggle), a
  ld a, 4
  ldh (<hram.stat_count), a
  ldh (<SCX), a
  ld a, 13
  ldh (<LYC), a
  ld a, %01000000
  ldh (<STAT), a
  ld a, INTR_STAT | INTR_TIMER
  ldh (<IE), a
  xor a
  ldh (<IF), a
  reti

.ends

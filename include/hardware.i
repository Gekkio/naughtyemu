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

.define INTR_JOYPAD %10000
.define INTR_SERIAL %01000
.define INTR_TIMER  %00100
.define INTR_STAT   %00010
.define INTR_VBLANK %00001

.define INTR_VEC_VBLANK $40
.define INTR_VEC_STAT   $48
.define INTR_VEC_TIMER  $50
.define INTR_VEC_SERIAL $58
.define INTR_VEC_JOYPAD $60

.define VRAM  $8000
.define OAM   $FE00
.define HIRAM $FF80

.define P1   $FF00
.define SB   $FF01
.define SC   $FF02
.define DIV  $FF04
.define TIMA $FF05
.define TMA  $FF06
.define TAC  $FF07
.define IF   $FF0F
.define NR10 $FF10
.define NR11 $FF11
.define NR12 $FF12
.define NR13 $FF13
.define NR14 $FF14
.define NR21 $FF16
.define NR22 $FF17
.define NR23 $FF18
.define NR24 $FF19
.define NR30 $FF1A
.define NR31 $FF1B
.define NR32 $FF1C
.define NR33 $FF1D
.define NR34 $FF1E
.define NR41 $FF20
.define NR42 $FF21
.define NR43 $FF22
.define NR44 $FF23
.define NR50 $FF24
.define NR51 $FF25
.define NR52 $FF26
.define LCDC $FF40
.define STAT $FF41
.define SCY  $FF42
.define SCX  $FF43
.define LY   $FF44
.define LYC  $FF45
.define DMA  $FF46
.define BGP  $FF47
.define OBP0 $FF48
.define OBP1 $FF49
.define WY   $FF4A
.define WX   $FF4B
.define IE   $FFFF

.define LCDC_ON       %10000000
.define LCDC_WND_MAP  %01000000
.define LCDC_WND_ON   %00100000
.define LCDC_BG_TILES %00010000
.define LCDC_BG_MAP   %00001000
.define LCDC_OBJ_SIZE %00000100
.define LCDC_OBJ_ON   %00000010
.define LCDC_BG_ON    %00000001

; +-------------+
; | subroutines |
; +-------------+

; general gfx routines
; -------------------------------------------------------------

; set location of 16k video bank seen by vic-ii chip.
; zp1 = bank number (0 = $0000-$3fff, 1 = $4000-$7fff,  
;                    2 = $8000-$bfff, 3 = $c000-$ffff)  
set_vic_bank    lda cia2+2
                ora #3
                sta cia2+2
                lda zp1
                cmp #4
                #jcs illqua
                lda cia2
                and #$fc
                ora $14
                eor #3
                sta cia2
                lda $14
                ror a
                ror a
                ror a
                and #$c0
                sta $14
                lda hibase
                and #$3f
                ora $14
                sta hibase
                rts

; set location of screen memory within 16k seen by vic-ii.
; zp1 = address (0-63) 1k block of memory within 16k video bank
set_screen_mem  lda zp1
                asl a
                asl a
                tax
                eor hibase
                and #$c0
                #jne illqua
                lda vic+$18
                and #$f
                sta vic+$18
                txa
                asl a
                asl a
                ora vic+$18
                sta vic+$18
                lda hibase
                txa
                ora hibase
                sta hibase
                rts
                
; low-res gfx routines
; -------------------------------------------------------------

; set location of basic screen editor cursor.
; zp1 = column (0-39)
; zp2 = row (0-24)
set_cursor_pos  ldy zp1
                cpy #40 
                #jcs illqua
                ldx zp2
                cpx #25
                #jcs illqua                
                clc
                jmp $fff0

; plot a low-res (2x2) "pixel".
; zp1 = column (0-79)
; zp2 = row (0-49)
; zp4 = mode (0 = set, 1 = clear, 2 = invert )
plot_lowres_px  .block
                lda #0
                sta zp3 ; mask
                lda zp4
                cmp #3
                #jcs illqua
                lda zp2
                cmp #50
                #jcs illqua
                lsr a
                sta zp2                                
                rol zp3
                lda zp1
                cmp #80
                #jcs illqua                                               
                lsr a
                sta zp1
                rol zp3
                jsr set_cursor_pos
                ldx zp3                
                lda mtab,x
                ldx zp4
                dex
                bne l0
                eor #$f                
l0              sta zp3                
                ldy $d3
                lda ($d1),y
                ldx #$f
l1              cmp chrtab,x                
                beq l2
                dex
                bne l1
l2              txa                
                ldx zp4
                beq set
                dex
                beq clr
                eor zp3
                jmp l3
clr             and zp3                
                jmp l3
set             ora zp3                
l3              tax                
                lda chrtab,x
                sta ($d1),y
                lda $d2
                ldx $d1
                and #3
                ora #$d8
                sta $f4
                sta $f3
                lda hibase
                sta ($f3),y
                rts
chrtab          .byte $20, $7e, $7c, $e2, $7b, $61, $ff, $ec
                .byte $6c, $7f, $e1, $fb, $62, $fc, $fe, $a0
mtab            .byte $01, $02, $04, $08                
                .bend
                
; node-related routines
; -------------------------------------------------------------

draw_nodes      lda #0
                sta zp4
                
                lda node_a.pos.x
                sta zp1
                lda node_a.pos.y
                sta zp2
                jsr plot_lowres_px                
                
                lda node_b.pos.x
                sta zp1
                lda node_b.pos.y
                sta zp2
                jsr plot_lowres_px
                
                lda node_c.pos.x
                sta zp1
                lda node_c.pos.y
                sta zp2
                jsr plot_lowres_px
                
                lda node_d.pos.x
                sta zp1
                lda node_d.pos.y
                sta zp2
                jsr plot_lowres_px
                
                rts
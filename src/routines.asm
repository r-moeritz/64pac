; +-------------+
; | subroutines |
; +-------------+

; general gfx routines
; -------------------------------------------------------------

; set location of 16k video bank seen by vic-ii chip.
; zp1 = bank number (0 = $0000-$3fff, 1 = $4000-$7fff,  
;                    2 = $8000-$bfff, 3 = $c000-$ffff)  
set_vic_bank    lda ci2pra+2
                ora #3
                sta ci2pra+2
                lda zp1
                cmp #4
                #jcs illqua
                lda ci2pra
                and #$fc
                ora zp1
                eor #3
                sta ci2pra
                lda zp1
                ror a
                ror a
                ror a
                and #$c0
                sta zp1
                lda hibase
                and #$3f
                ora zp1
                sta hibase
                rts

; set location of screen memory within 16k seen by vic-ii.
; x = address (0-63) of 1k memory block within 16k video bank
set_screen_mem  txa
                asl a
                asl a
                tax
                eor hibase
                and #$c0
                #jne illqua
                lda vmcsb
                and #$f
                sta vmcsb
                txa
                asl a
                asl a
                ora vmcsb
                sta vmcsb
                lda hibase
                txa
                ora hibase
                sta hibase
                rts
                
; low-res gfx routines
; -------------------------------------------------------------

; copy charset from chargen rom to ram
; zp1 = address (0-63) of 1k memory block within 16k video bank
; overwrites zp1 and zp2
copy_charset    lda zp1
                asl a
                asl a
                sta zp2
                lda #0
                sta zp1
                sta $58
                ldy #$10
                sty $59
                sta $5a
                ldy #$e0
                sty $5b
                sta $5f
                ldy #$d0
                sty $60
                #adc_words $58, zp1
                lda ci1cr
                and #$fe
                sta ci1cr
                lda $01
                and #$fb
                sta $01
                jsr bltuc
                lda $01
                ora #4
                sta $01
                lda ci1cr
                ora #1
                sta ci1cr
                rts

; set the vic-ii character data pointer
; zp1 = address (0-63) of 1k memory block within 16k video bank
; overwrites zp2
set_chrptr      lda zp1
                asl a
                asl a
                eor hibase
                and #$c0
                #jne illqua
                lda zp1
                and #$f
                sta zp2
                lda vmcsb
                and #$f0
                ora zp2
                sta vmcsb
                rts

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
                jmp plot

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
                
; i/o routines
; -------------------------------------------------------------

; scan for joystick input on port 2
;
; after calling, zp3 and zp4 contain movement information.
;
; zp3 = $00   no change on x-axis
; zp3 = $01   moved right
; zp3 = $ff   moved left
; zp4 = $00   no change on y-axis
; zp4 = $01   moved down
; zp4 = $ff   moved up
;
; if carry is clear (c=0) then fire button was pressed.
scan_joystick_2 .block
                lda ci1pra
djrrb           ldy #0
                ldx #0
                lsr
                bcs djr0
                dey
djr0            lsr
                bcs djr1
                iny
djr1            lsr
                bcs djr2
                dex
djr2            lsr
                bcs djr3
                inx
djr3            lsr
                stx zp3
                sty zp4
                rts
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
                
                lda node_e.pos.x
                sta zp1
                lda node_e.pos.y
                sta zp2
                jsr plot_lowres_px
                
                rts
                
; sprite-related routines
; -------------------------------------------------------------

; enable sprites, set sprite data & initial positions
setup_sprites   .block
                lda sprite_0_pos.x
                sta sp0x
                lda sprite_0_pos.x+1
                beq clrxmsb                
                lda msigx
                ora #%00000001
                sta msigx
                jmp setspry
                
clrxmsb         lda msigx
                and #%11111110
                sta msigx                
                
setspry         lda sprite_0_pos.y
                sta sp0y
                
                #set_sprite_data 0, #balloon_spdata                                
                #enable_sprites #1                
                rts               
                .bend
                
; interrupt routines                
; -------------------------------------------------------------

; register irq handler and enable raster interrupts
register_irq    sei
                lda #<handle_irq
                sta cinv
                lda #>handle_irq
                sta cinv+1
                lda #rasterln
                sta raster
                lda scroly
                and #%01111111                  ; erase highbyte
                sta scroly
                lda #%10000001                  ; enable raster interrupt
                sta irqmsk
                cli
                rts
                
; interrupt handler
handle_irq      lda vicirq
                sta vicirq                      ; erase vic-ii irq register
                bmi rasirq

                ; system interrupt
                lda ci1icr                      ; erase cia 1 irq register
                cli
                jmp sysirq

                ; raster interrupt
rasirq          lda raster
                cmp #rasterln
                beq setsprx
                jmp exitirq
setsprx         lda sprite_0_pos.x
                sta sp0x
setxmsb         lda sprite_0_pos.x+1
                beq clrxmsb
                lda msigx
                ora #%00000001
                sta msigx
                jmp setspry
clrxmsb         lda msigx
                and #%11111110
                sta msigx
setspry         lda sprite_0_pos.y
                sta sp0y
exitirq         jmp restore
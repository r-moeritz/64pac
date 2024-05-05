; +----------------------------+
; | main program code of 64pac |
; +----------------------------+

* = $0801

                ; basic header
                .word (+), 2005                 ; pointer, line number
                .null $9e, format("%4d", main)  ; sys <decimal address of main>
+               .word 0                         ; basic line end     

; include modules
; -------------------------------------------------------------

.include "macros.asm"
.include "sysdefs.asm"
.include "constants.asm"
.include "ramdefs.asm"
.include "routines.asm"
.include "structs.asm"
.include "datadefs.asm"

; program entry
; -------------------------------------------------------------
main            .block               
                #set_bg_colours #0, #0
                jsr clrscn                
                jsr draw_nodes                                                
                jsr setup_sprites                
                jsr register_irq                
                
                ; loop until stop key pressed
gameloop        jsr stop                
                #jeq reset                      ; sys 64738                
                jsr scan_joystick_2
                ldx #$05
delay0          ldy #$ff
delay1          dey
                bne delay1
                dex
                bne delay0
check_x         lda #1
                cmp zp3
                beq move_right
                bcs check_y
                #dec_word sprite_0_pos.x        ; move left                
                jmp gameloop
move_right      #inc_word sprite_0_pos.x
                jmp gameloop
check_y         lda #1
                cmp zp4
                beq move_down
                #jcs gameloop
                dec sprite_0_pos.y              ; move up
                jmp gameloop
move_down       inc sprite_0_pos.y                
                jmp gameloop                
                .bend

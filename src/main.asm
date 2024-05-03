; +----------------------------+
; | main program code of 64pac |
; +----------------------------+

*= $c000

jmp main

; include modules
; -------------------------------------------------------------

.include "macros.asm"
.include "sysdefs.asm"
.include "routines.asm"
.include "structs.asm"
.include "ramdefs.asm"
.include "datadefs.asm"

; program entry
; -------------------------------------------------------------
main            .block
                #clear_screen
                #set_bg_colours #0, #0
                
                jsr draw_nodes
                ; loop until stop key pressed
loop            jsr stop                
                bne loop
                rts
                .bend

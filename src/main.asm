; +----------------------------+
; | main program code of 64pac |
; +----------------------------+

* = $0801

                ; basic header
                .word (+), 2005                 ; pointer, line number
                .null $9e, format("%4d", main)  ; sys <decimal address of init>
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
                
                ; loop until stop key pressed
loop            jsr stop                
                bne loop
                rts
                .bend

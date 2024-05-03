; +-----------------+
; | data structures |
; +-----------------+

; 2d vector ds
vector2         .struct xpos, ypos
x               .word \xpos
y               .byte \ypos
                .ends

; node ds
node            .struct xpos, ypos
pos             .dstruct vector2, \xpos, \ypos
up              .byte 0
down            .byte 0
left            .byte 0
right           .byte 0
                .ends
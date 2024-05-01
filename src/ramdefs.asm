; +-----------------+
; | ram definitions |
; +-----------------+

; data structures
; ---------------

; node ds
node      .struct xpos, ypos
x         .word \xpos
y         .byte \ypos
up        .byte 0
down      .byte 0
left      .byte 0
right     .byte 0
          .ends

; vector ds
vector    .struct xpos, ypos
x         .word \xpos
y         .byte \ypos
          .ends

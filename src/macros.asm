; +---------------------------------+
; | macro definitions used by 64pac |
; +---------------------------------+

; 16-bit operations
; -----------------

; increment a word
; lo = low byte of word address
dbinc     .macro lo
          lda \lo
          clc
          adc #1
          sta \lo
          lda #0
          adc \lo+1
          sta \lo+1
          .endm

; decrement a word
; lo = low byte of word address
dbdec     .macro lo
          lda \lo
          sec
          sbc #1
          sta \lo
          lda \lo+1
          sbc #0
          sta \lo+1
          .endm

; cmp a word to a 16-bit value in immediate mode
; lo = low byte of word address
; wrd = literal 16-bit value to compare against
dbcmpi    .macro lo, wrd
          lda \lo+1
          cmp #>\wrd
          bcc fin
          bne fin
          lda \lo
          cmp #<\wrd
fin       .endm

; add a byte to a word
; lo = low byte of word address
; byt = byte to add
dbadc     .macro lo, byt
          lda \lo
          clc
          adc \byt
          sta \lo
          lda #0
          adc \lo+1
          sta \lo+1
          .endm
          
; subtract a byte from a word
; lo = low byte of word address
; byt = byte to subtract
dbsbc     .macro lo, byt
          lda \lo
          sec
          sbc \byt
          sta \lo
          lda \lo+1
          sbc #0
          sta \lo+1
          .endm         

; conditional jumps
; -----------------

jcc       .macro adr
          bcs fin
          jmp \adr
fin       .endm

jcs       .macro adr
          bcc fin
          jmp \adr
fin       .endm

jeq       .macro adr
          bne fin
          jmp \adr
fin       .endm

jne       .macro adr
          beq fin
          jmp \adr
fin       .endm

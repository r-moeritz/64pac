; +------------------+
; | data definitions |
; +------------------+

                ; nodes
node_a          .dstruct node, 16, 24
node_b          .dstruct node, 36, 24
node_c          .dstruct node, 56, 24
node_d          .dstruct node, 36, 10
node_e          .dstruct node, 36, 38

                ; sprite 0 position
sprite_0_pos    .dstruct vector2, 100, 100
       
                ; balloon sprite         
                .align 64
balloon_spdata  .byte 0,127,0,1,255,192,3,255,224,3,231,224
                .byte 7,217,240,7,223,240,7,217,240,3,231,224
                .byte 3,255,224,3,255,224,2,255,160,1,127,64
                .byte 1,62,64,0,156,128,0,156,128,0,73,0,0,73,0,0
                .byte 62,0,0,62,0,0,62,0,0,28,0
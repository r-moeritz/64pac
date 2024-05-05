; +---------------------------+
; | system memory definitions |
; +---------------------------+

hibase = $0288
cinv = $0314                    ; irq vector

; vic-ii memory
vic = $d000
sp0x = vic
sp0y = vic+$01
msigx = vic+$10
scroly = vic+$11
raster = vic+$12
spena  = vic+$15
vmcsb  = vic+$18
vicirq = vic+$19
irqmsk = vic+$1a

; i/o
ci1pra   = $dc00
ci1icr   = ci1pra+$0d
ci1cr    = ci1pra+$0e
ci2pra   = $dd00

; basic routines
bltuc = $a3bf
illqua = $b248

; kernal routines
clrscn = $e544
sysirq = $ea31
restore = $ea7e
reset = $fce2
bsout = $ffd2
stop = $ffe1
plot = $fff0
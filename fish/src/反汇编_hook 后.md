(lldb) x/4gx 0x0000000104c30000+0xC000
0x104c3c000: 0x000000019282eba8 0x0000000192822320
0x104c3c010: 0x0000000193e906b4 0x0000000104c36494
(lldb) dis -s 0x000000019282eba8
Foundation`NSLog:
    0x19282eba8 <+0>:  pacibsp 
    0x19282ebac <+4>:  sub    sp, sp, #0x20             ; =0x20 
    0x19282ebb0 <+8>:  stp    x29, x30, [sp, #0x10]
    0x19282ebb4 <+12>: add    x29, sp, #0x10            ; =0x10 
    0x19282ebb8 <+16>: adrp   x8, 342965
    0x19282ebbc <+20>: ldr    x8, [x8, #0x900]
    0x19282ebc0 <+24>: ldr    x8, [x8]
    0x19282ebc4 <+28>: str    x8, [sp, #0x8]
    
    
    
    
    
    
// hook 后




    
    
(lldb)  x/4gx 0x0000000104c30000+0xC000
0x104c3c000: 0x0000000104c35310 0x0000000192822320
0x104c3c010: 0x0000000193e906b4 0x000000019a901d1c
(lldb) dis -s 0x0000000104c35310
66666`myNSLog:
    0x104c35310 <+0>:  sub    sp, sp, #0x30             ; =0x30 
    0x104c35314 <+4>:  stp    x29, x30, [sp, #0x20]
    0x104c35318 <+8>:  add    x29, sp, #0x20            ; =0x20 
    0x104c3531c <+12>: sub    x8, x29, #0x8             ; =0x8 
    0x104c35320 <+16>: mov    x9, #0x0
    0x104c35324 <+20>: stur   xzr, [x29, #-0x8]
    0x104c35328 <+24>: str    x0, [sp, #0x10]
    0x104c3532c <+28>: mov    x0, x8
(lldb) 

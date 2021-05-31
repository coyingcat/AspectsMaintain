
### fish hook 的流程


在 rebind 之前，


通过 mach-o, 找到了符号


<hr>

通过符号地址，找到了符号里面的值


<hr>



通过符号里面的值，找到了 NSLog 的地址


<hr>

<hr>


<hr>


fish hook 就是读 mach - o 文件里面的符号


然后将该符号，重新绑定

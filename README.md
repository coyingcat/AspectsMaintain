




### fish hook 的流程





![fish hook](https://github.com/coyingcat/AspectsMaintain/blob/master/imgs/0.png?raw=true)




> C 语言，动态的特性，就是绑定符号



//  自定义函数没有，该动态特性
//  因为我们不需要绑定





#### 动态缓存库


共享缓存库： 系统的所有的函数实现，和方法实现，都在系统的动态缓存库里面




<hr>






NSLog 的代码实现，就在动态缓存库中,
他的地址，不能确定



很可能，每一次开机，他 （ NSLog ） 的地址就变了

每一个不同型号的手机，不同的系统版本，每一个不同的状态
NSLog 所在的内存地址，很可能是不一样的




<hr>


<hr>


代码，编译为二进制


二进制，安装在手机硬盘上


应用程序启动，二进制从手机硬盘，加载到手机内存中


<hr>


<hr>


C 语言，是静态语言


C 语言写的函数，写了之后，就得到了其地址


<hr>


<hr>



所有调用系统的函数的 C 代码，


调用（系统的函数 NSLog ）的代码，会生成一个地址


（ 系统的函数 NSLog ）的代码实现，不处于应用的包里面


（ 系统的函数 NSLog ）的代码实现，在动态缓存库里面





<hr>


<hr>




写了一个调用 NSLog 的代码，

在编译的时候，没有运行到手机上的时候，

该 NSLog 函数的地址，不可确定


#### 编译阶段, 根本不能确定，该函数的地址，在哪里




编译阶段，iOS 的设计，

在文件中，添加了一个 8 个字节的位置

（ 保存一个地址 ）


作为符号，放在数据中





<hr>


<hr>




对应调用一个系统的函数的时候，


他就提供了 8 个字节存储，系统函数的地址


这  8 个字节，就是一个符号









<hr>


编译阶段，




（ 系统的函数 NSLog ），先指向符号


这个符号，8 个字节，里面又是一个内存地址





<hr>


dyld 

dynamic load  动态加载

动态链接



dyld 读你的 mach-o 文件，从上往下读


dyld 读取 mach-o 文件，要加载的依赖库


告诉 NSLog 实际的地址 (    把   NSLog 代码实现的地址，赋值到对应的符号上面去  )

此时，符号有了真实的地址


<hr>

























## iOS 安全:


用汇编，去写防护代码



逆向，可以学习系统底层和应用安全



<hr>


打包的二进制文件，

分为代码段 text  ( 只读 )
和数据段 data （ 可读可写的 ）





fish hook 当然是，只能更改数据段 
fish hook 只能更改，可读可写的



<hr>

<hr>



dyld 加载符号，分两种情况，


* 懒加载符号


当你用到那个函数的时候，才把系统的那个值，给赋值了




* 非懒加载符号


只要运行这个程序，


我就会把 data 段的这些符号，都给赋上值




<hr>


为了提高应用启动的效率，

可通过懒加载






<hr>
<hr>

<hr>

<hr>


MachOView 找到偏移，


符号是用来，保存地址的








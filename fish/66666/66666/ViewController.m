//
//  ViewController.m
//  66666
//
//  Created by Jz D on 2021/5/25.
//

#import "ViewController.h"

#import "fishhook.h"




// ---   用例:  更改系统的 NSLog 函数   ---


//  函数指针,用来保存
//  原始的函数的地址
static void (*old_nslog)(NSString *format, ...);



//新的 NSLog
void myNSLog(NSString *format, ...){
    format = [format stringByAppendingString:@"\n勾上了!"];
    //再调用原来的  NSLog
    old_nslog(format);
}



@interface ViewController()

@end





@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"123");
    //定义rebinding结构体
/*
struct rebinding {
  const char *name;//需要HOOK的函数名称,字符串
  void *replacement;//替换到那个新的函数上(函数指针,也就是函数的名称)
  void **replaced;//保存原始函数指针变量的指针(它是一个二级指针!)
};
*/
    struct rebinding nslogBind;
    //函数的名称
    nslogBind.name = "NSLog";       // C 字符串， 要交换的是
    
    
    
    
    
    //新的函数地址
    // 函数名称，就是函数地址
    nslogBind.replacement = myNSLog;    //  交换为，新的函数的地址
    
    
    
    
    
    
    
    
    
    // 要交换的，原始的函数地址，放在哪里呢
    // 也就是例子中， 系统的 NSLog 的原始实现
    
    // 保存， 原始函数地址的， 变量的指针
    nslogBind.replaced = (void *)&old_nslog;   // 要给这个指针， 的地址
    // 都是 C 函数
    // C 函数，都是值传递
    
    
    //  给这个指针， 的值 old_nslog
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //定义数组
    struct rebinding rebs[1] = {nslogBind};
    
    
    /*
     
     用于重新绑定符号
     
     arg1 : 存放 rebinding 结构体的数组
     
     
     
     arg2 : 数组的长度
     */
    rebind_symbols(rebs, 1);
    
    NSLog(@"修改完毕了");
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了屏幕!!");
}


@end









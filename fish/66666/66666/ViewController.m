//
//  ViewController.m
//  66666
//
//  Created by Jz D on 2021/5/25.
//

#import "ViewController.h"

#import "fishhook.h"




// ---   用例:  更改系统的 NSLog 函数   ---


// 函数指针,用来保存  原始的函数的地址
static void (*old_nslog)(NSString *format, ...);



//新的 NSLog
void myNSLog(NSString *format, ...){
    format = [format stringByAppendingString:@"\n勾上了!"];
    //再调用原来的
    old_nslog(format);
}



@interface ViewController ()

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
    nslogBind.name = "NSLog";
    //新的函数地址
    nslogBind.replacement = myNSLog;
    //保存原始函数地址的变量的指针
    nslogBind.replaced = (void *)&old_nslog;
    //定义数组
    struct rebinding rebs[] = {nslogBind};
    /*
     arg1 : 存放rebinding结构体的数组
     arg2 : 数组的长度
     */
    rebind_symbols(rebs, 1);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击了屏幕!!");
}


@end







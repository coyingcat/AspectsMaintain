//
//  AspectsAppDelegate.m
//  AspectsDemo
//
//  Created by Peter Steinberger on 03/05/14.
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//

#import "AspectsAppDelegate.h"
#import "AspectsViewController.h"
#import "Aspects.h"

@implementation AspectsAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AspectsViewController *aspectsController = [AspectsViewController new];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:aspectsController];
    [self.window makeKeyAndVisible];

  
        [aspectsController aspect_hookSelector:@selector(buttonPressed:) withOptions:0 usingBlock:^(id info, id sender) {
            NSLog(@"Button was pressed by: %@", sender);
        } error:NULL];

        [aspectsController aspect_hookSelector:@selector(viewWillLayoutSubviews) withOptions:0 usingBlock:^{
            NSLog(@"Controller is layouting!");
        } error:NULL];
    

    return YES;
}

@end




/*
 
 
 
 把要执行的方法，
 
 拆分，
 
 拿到需要的信息
 
 
 组合
 
 
 把需要的信息，组合成方法，
 
 换了一个地方调用
 
 
 
 */




/*
 
 源代码，
 
 
 感性认识
 
 
 */

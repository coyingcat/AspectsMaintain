//
//  AppDelegate.m
//  oc
//
//  Created by Jz D on 2022/5/29.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

NSInteger i = 0;

#import <objc/runtime.h>

@implementation UICollectionView (Config)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(initWithCoder:);
        SEL swizzledSelector = @selector(initWithCoderXx:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
            class_addMethod(class,
                originalSelector,
                method_getImplementation(swizzledMethod),
                method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
        SEL originalFrameSel = @selector(initWithFrame:collectionViewLayout:);
        SEL swizzledFrameSel = @selector(initWithFrameXx:collectionViewLayout:);

        Method originalFrameM = class_getInstanceMethod(class, originalFrameSel);
        Method swizzledFrameM = class_getInstanceMethod(class, swizzledFrameSel);
        BOOL didAddMethodFrame =
            class_addMethod(class,
                            originalFrameSel,
                method_getImplementation(swizzledFrameM),
                method_getTypeEncoding(swizzledFrameM));

        if (didAddMethodFrame) {
            class_replaceMethod(class,
                                swizzledFrameSel,
                method_getImplementation(originalFrameM),
                method_getTypeEncoding(originalFrameM));
        } else {
            method_exchangeImplementations(originalFrameM, swizzledFrameM);
        }
    });
}

#pragma mark - Method Swizzling
- (instancetype)initWithCoderXx:(NSCoder *)coder{
    UICollectionView * view = [self initWithCoderXx: coder];
    [view setBackgroundColor: UIColor.orangeColor];
    NSLog(@"%ld", i);
    i += 1;
    return view;
}



- (instancetype)initWithFrameXx:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    UICollectionView * view = [self initWithFrameXx: frame collectionViewLayout: layout];
    [view setBackgroundColor: UIColor.orangeColor];
    NSLog(@"%ld", i);
    i += 1;
    return view;
}

@end

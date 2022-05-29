//
//  UIWindow+List.m
//  swift
//
//  Created by Jz D on 2022/5/29.
//

#import "List.h"


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

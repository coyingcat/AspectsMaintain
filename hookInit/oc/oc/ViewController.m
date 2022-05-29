//
//  ViewController.m
//  oc
//
//  Created by Jz D on 2022/5/29.
//

#import "ViewController.h"



@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    UICollectionView * upList = [[UICollectionView alloc] initWithFrame: CGRectMake(50, 50, 150, 150) collectionViewLayout: [[UICollectionViewFlowLayout alloc] init]];
    [self.view addSubview: upList];
    
    
}



@end


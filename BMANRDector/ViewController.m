//
//  ViewController.m
//  BMANRDector
//
//  Created by baidu on 16/5/23.
//  Copyright © 2016年 wyf && BaiDu Map Iphone Team All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIButton *_btn;
    UIButton *_btn1;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn = [[UIButton alloc] init];
    _btn.frame = CGRectMake(60, 100, 100, 50);
    _btn.backgroundColor = [UIColor yellowColor];
    [_btn setTitle:@"triger ANR" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(triggerANR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    
    _btn1 = [[UIButton alloc] init];
    _btn1.frame = CGRectMake(60, 100 + 60, 100 + 50, 50);
    _btn1.backgroundColor = [UIColor yellowColor];
    [_btn1 setTitle:@"not triger ANR" forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(triggerNotANR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(mockANROrFreeze) withObject:nil afterDelay:2];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mockANROrFreeze
{
    sleep(6);
}


- (void)triggerANR:(UIButton *)btn
{
    [self performSelector:@selector(mockANROrFreeze) withObject:nil afterDelay:0];
}

- (void)triggerNotANR:(UIButton *)btn
{
    [self performSelector:@selector(unSleep) withObject:nil afterDelay:2];
}

- (void)unSleep
{
    NSLog(@"not trigger");
}
@end

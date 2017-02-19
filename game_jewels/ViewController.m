//
//  ViewController.m
//  game_jewels
//
//  Created by ReTah_Liu on 17/2/16.
//  Copyright © 2017年 ReTah_Liu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)startGame
{
    _countDown = 61;
    
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
    _timeLabel.text = [NSString stringWithFormat: @"%ld", (long)_countDown];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 10, 100, 30)];
    
    _timeLabel.textColor = [UIColor redColor];
    [self.view addSubview:_timeLabel];
    
    NSMutableArray *arrStr = [[NSMutableArray alloc] init];
    
    for (int k = 0; k < 42; k++) {
        int random = arc4random() % 7 + 1;
        
        NSString *strName = [NSString stringWithFormat:@"%d", random];
        
        [arrStr addObject:strName];
        [arrStr addObject:strName];
    }
    
    for (int i = 0; i < 12; i ++) {
        for (int j = 0; j < 7; j ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame = CGRectMake(self.view.frame.size.width / 2 - 10, self.view.frame.size.height / 2 - 40, 50, 50);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:2];
            
            btn.frame = CGRectMake(10+50*j, 40+50*i, 50, 50);
            
            [UIView commitAnimations];
            
            int indexRandom = arc4random() % arrStr.count;
            
            NSString *strImage = arrStr[indexRandom];
            
            NSInteger tag = [strImage integerValue];
            
            [arrStr removeObjectAtIndex:indexRandom];
            
            NSString *str1 = @"jewel";
            NSString *str2 = [str1 stringByAppendingString:strImage];
            
            UIImage *image = [UIImage imageNamed:str2];
            
            [btn setImage:image forState:UIControlStateNormal];
            
            [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:btn];
            
            btn.tag = tag;
        }
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)timerFireMethod
{
    _countDown--;
    if (_countDown == 0) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"时间到！" message:@"闯关失败了！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"再玩一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self startGame];
        }];
        //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //    [alertController addAction:cancelAction];
        [alertController addAction:restartAction];
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"失败了！");
    }
    _timeLabel.text = [NSString stringWithFormat: @"%ld", (long)_countDown];
}

- (void)finishGame
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"恭喜" message:@"成功过关了！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *restartAction = [UIAlertAction actionWithTitle:@"再玩一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self startGame];
    }];
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //    [alertController addAction:cancelAction];
    [alertController addAction:restartAction];
    [self presentViewController:alertController animated:YES completion:nil];
    NSLog(@"过关了！");
}

- (void)pressBtn:(UIButton *) btn
{
    static UIButton *firstBtn = nil;
    
    if (firstBtn == nil) {
        firstBtn = btn;
        firstBtn.enabled = NO;
    }
    else {
        if (firstBtn.tag == btn.tag) {
            [firstBtn removeFromSuperview];
            [btn removeFromSuperview];
            firstBtn = nil;
            NSLog(@"same");
            if ([self.view.subviews count] <= 1) {
                [_countDownTimer invalidate];
                _countDownTimer = nil;
                [self finishGame];
            }
        }
        else {
            firstBtn.enabled = YES;
            firstBtn = nil;
            NSLog(@"different");
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

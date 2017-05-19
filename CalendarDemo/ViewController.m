//
//  ViewController.m
//  Calendar
//
//  Created by yunlong on 17/5/12.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "ViewController.h"
#import "HotelCalendarViewController.h"
@interface ViewController ()
@property(nonatomic,strong) UILabel *startDateLabel;
@property(nonatomic,strong) UILabel *endDateLabel;
@property(nonatomic,strong) UILabel *numLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UILabel *startLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 80, 40)];
    startLabelTitle.textColor = [UIColor blackColor];
    startLabelTitle.font = [UIFont systemFontOfSize:12];
    startLabelTitle.textAlignment = NSTextAlignmentLeft;
    startLabelTitle.text = @"入住时间：";
    [self.view addSubview:startLabelTitle];
    
    _startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,80, [UIScreen mainScreen].bounds.size.width - 100, 40)];
    _startDateLabel.textColor = [UIColor blackColor];
    _startDateLabel.font = [UIFont systemFontOfSize:12];
    _startDateLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_startDateLabel];
    
    UILabel *endLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 80, 50)];
    endLabelTitle.textColor = [UIColor blackColor];
    endLabelTitle.font = [UIFont systemFontOfSize:12];
    endLabelTitle.textAlignment = NSTextAlignmentLeft;
    endLabelTitle.text = @"离店时间：";
    [self.view addSubview:endLabelTitle];
    
    _endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,120,[UIScreen mainScreen].bounds.size.width - 100, 40)];
    _endDateLabel.textColor = [UIColor blackColor];
    _endDateLabel.font = [UIFont systemFontOfSize:12];
    _endDateLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_endDateLabel];
    
    UILabel *numLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 170, 80, 50)];
    numLabelTitle.textColor = [UIColor blackColor];
    numLabelTitle.font = [UIFont systemFontOfSize:12];
    numLabelTitle.textAlignment = NSTextAlignmentLeft;
    numLabelTitle.text = @"总天数：";
    [self.view addSubview:numLabelTitle];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(100,170, [UIScreen mainScreen].bounds.size.width - 100, 40)];
    _numLabel.textColor = [UIColor blackColor];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_numLabel];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 250, [UIScreen mainScreen].bounds.size.width - 60, 40)];
    [btn setTitle:@"请选择入住时间" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnClick{
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [vc setSelectCheckDateBlock:^(NSString *startDateStr, NSString *endDateStr, NSString *daysStr) {
        weakSelf.startDateLabel.text = startDateStr;
        weakSelf.endDateLabel.text = endDateStr;
        weakSelf.numLabel.text = daysStr;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

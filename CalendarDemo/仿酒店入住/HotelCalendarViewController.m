//
//  HotelCalendarViewController.m
//  BJTResearch
//
//  Created by yunlong on 17/5/11.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "HotelCalendarViewController.h"
#import "MonthModel.h"
#import "MonthTableViewCell.h"

@interface HotelCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIView *weekView;
@end

@implementation HotelCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"仿酒店入住时间";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(selectedCheckDate)];
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.tableView];

}

/////////////////////////////////////创建视图///////////////////////////////////////////
#pragma mark - 创建主视图
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekView.frame), self.view.bounds.size.width, self.view.bounds.size.height - self.weekView.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    }
    return _tableView;
}

#pragma mark - 创建星期视图
-(UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc]initWithFrame:CGRectMake(-1, 63, self.view.bounds.size.width+2, 40)];
        NSArray *title = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
        for (int i =0 ; i < 7 ; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/7*i+1, 0, self.view.bounds.size.width/7, _weekView.bounds.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title[i];
            if (i>4) {
                label.textColor = [UIColor orangeColor];
            }
            [_weekView addSubview:label];
        }
        _weekView.backgroundColor = [UIColor whiteColor];
        _weekView.layer.borderWidth = 1;
        _weekView.layer.masksToBounds = YES;
        _weekView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    }
    return _weekView;
}


/////////////////////////////////////点击事件///////////////////////////////////////////
#pragma mark - 确定事件返回
-(void)selectedCheckDate{
    NSDate *startDate;
    BOOL isHaveStartDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateStart) {
                isHaveStartDate = YES;
                startDate = mo.dayDate;
                break;
            }
        }
    }
    NSDate *endDate;
    BOOL isHaveEndDate = NO;
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *mo in Mo.days) {
            if (mo.state == DayModelStateEnd) {
                isHaveEndDate = YES;
                endDate = mo.dayDate;
                break;
            }
        }
    }
    if (isHaveStartDate && isHaveEndDate) {
        NSInteger days = [self calcDaysFromBegin:startDate end:endDate];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        NSString *endDateStr = [dateFormatter stringFromDate:endDate];
        NSString *daysStr = [NSString stringWithFormat:@"%ld",days];
        if (_selectCheckDateBlock) {
            _selectCheckDateBlock(startDateStr,endDateStr,daysStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        return ;
    }
    
}

/////////////////////////////////////代理方法///////////////////////////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthModel *model = self.dataArray[indexPath.row];
    return model.cellHight;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthTableViewCell *cell = [MonthTableViewCell cellWithTableView:tableView];
    cell.model =  self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.selectedDay = ^(DayModel *returnDaymodel){
        BOOL isHaveStart = NO;
        BOOL isHaveEnd = NO;
        BOOL isHaveSelected = NO;
        NSDate *startDate ;
        NSDate *endDate ;
        DayModel *starModel;
        DayModel *endModel;
        for (MonthModel *Mo in self.dataArray) {
            for (DayModel *mo in Mo.days) {
                if (mo.state == DayModelStateStart) {
                    isHaveStart = YES;
                    startDate = mo.dayDate;
                    starModel = mo;
                }else if (mo.state == DayModelStateSelected) {
                    isHaveSelected = YES;
                }else if (mo.state == DayModelStateEnd) {
                    isHaveEnd = YES;
                    endDate = mo.dayDate;
                    endModel = mo;
                    break;
                }
            }
        }
        
        if ((!isHaveStart && !isHaveEnd && !isHaveSelected )|| (!isHaveStart && !isHaveEnd) ) {
            //没有设置开始结束
            returnDaymodel.state = DayModelStateStart;
        }else if ((isHaveEnd && isHaveStart)){
            //有开始有结束
            for (MonthModel *Mo in weakSelf.dataArray) {
                for (DayModel *mo in Mo.days) {
                    mo.state = DayModelStateNormal;
                }
            }
            returnDaymodel.state = DayModelStateStart;
        }else if(isHaveStart && !isHaveEnd){
            //有开始没有结束
            NSInteger ci = [self compareDate:returnDaymodel.dayDate withDate:startDate];
            switch (ci) {
                case 1://startDate > currentSelectDate
                    starModel.state = DayModelStateNormal;
                    returnDaymodel.state = DayModelStateStart;
                    break;
                case -1:
                    returnDaymodel.state = DayModelStateEnd;
                    for (MonthModel *Mo in weakSelf.dataArray) {
                        for (DayModel *mo in Mo.days) {
                            NSInteger ci1 = [weakSelf compareDate:mo.dayDate withDate:startDate];
                            NSInteger ci2 = [weakSelf compareDate:mo.dayDate withDate:returnDaymodel.dayDate];
                            if (ci1 == -1 && ci2 == 1 ) {
                                mo.state = DayModelStateSelected;
                            }
                        }
                    }
                    break;
                case 0:
                    returnDaymodel.state = DayModelStateNormal;
                    break;
                default:
                    break;
            }

        }
        [weakSelf.tableView reloadData];
        
    };
    return cell;
}

/////////////////////////////////////数据处理///////////////////////////////////////////
#pragma mark - 懒加载数据源
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSDate *nowdate = [NSDate date];
        NSInteger toYear = [self getDataFromDate:nowdate type:@"year"];
        NSInteger toMonth = [self getDataFromDate:nowdate type:@"month"];
        for (int i = 0; i<13; i++) {
            if (i == 0) {
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = toYear;
                monthModel.month = toMonth;
                NSMutableArray *days = [NSMutableArray array ];
                NSInteger starNum = [self getDataFromDate :nowdate type:@"day"];
                for (NSInteger i = starNum ; i <=[self totaldaysInMonth:nowdate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    dayModel.dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    dayModel.isToday = i==starNum;
                    dayModel.state = DayModelStateNormal;
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( 7 - m.dayOfTheWeek + 2 ) % 7;
                if (oneLineCoune == 0) {
                    oneLineCoune = 7;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%7==0) {
                    lineCount = lineCount + count/7 ;
                }else{
                    lineCount = lineCount + count/7 + 1 ;
                    
                }
                monthModel.cellNum = lineCount * 7;
                monthModel.cellStartNum = 7 - oneLineCoune ;
                monthModel.cellHight = 60 + 60 * lineCount + 2 * (lineCount + 1);
                
                [_dataArray addObject:monthModel];
                toMonth++;
                
            }else{
                if (toMonth == 13) {
                    toMonth = 1;
                    toYear += 1;
                }
                NSDate *toDate = [self dateWithYear:toYear month:toMonth day:1];
                
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = [self getDataFromDate:toDate type:@"year"];
                monthModel.month = [self getDataFromDate:toDate type:@"month"];
                NSMutableArray *days = [NSMutableArray array ];
                for (NSInteger i = 1 ; i <=[self totaldaysInMonth:toDate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    dayModel.dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    dayModel.isToday = NO;
                    dayModel.state = DayModelStateNormal;
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( 7 - m.dayOfTheWeek + 2 ) % 7;
                if (oneLineCoune == 0) {
                    oneLineCoune = 7;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%7==0) {
                    lineCount = lineCount + count/7 ;
                }else{
                    lineCount = lineCount + count/7 + 1 ;
                    
                }
                monthModel.cellNum = lineCount * 7;
                monthModel.cellStartNum = 7 - oneLineCoune ;
                monthModel.cellHight = 60 + 60 * lineCount + 2 * (lineCount + 1);
                
                [_dataArray addObject:monthModel];
                toMonth++;
            }
        }
    }
    return _dataArray;
}

#pragma mark - 获取年，月，日，星期 注：日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
-(NSInteger )getDataFromDate:(NSDate *)date type:(NSString * )type{
    NSCalendar *calendar = nil;
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:date];
    if ([type isEqualToString:@"year"]) {
        return components.year;
    }else if ([type isEqualToString:@"month"]) {
        return components.month;
    }else if ([type isEqualToString:@"day"]) {
        return components.day;
    }else if ([type isEqualToString:@"week"]) {
        return components.weekday;
    }else{
        return 0;
    }
}

#pragma mark -- 获取当前月共有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

#pragma mark - 时间字符串转时间
-(NSDate *)dateWithYear:(NSInteger )year month:(NSInteger )month day:(NSInteger )day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter dateFromString:[NSString stringWithFormat:@"%ld%02ld%02ld",year,month,day]];
}

#pragma mark-日期比较
-(NSInteger )compareDate:(NSDate *)date01 withDate:(NSDate *)date02{
    NSInteger ci;
    NSComparisonResult result = [date01 compare:date02];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", date02, date01); break;
    }
    return ci;
}


#pragma mark - <#content#> 计算两个日期之间的天数
- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

@end




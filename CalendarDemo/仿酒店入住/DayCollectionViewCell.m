//
//  DayCollectionViewCell.m
//  BJTResearch
//
//  Created by yunlong on 17/5/11.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "DayCollectionViewCell.h"
#import "MonthModel.h"

#define NormalColor [UIColor whiteColor]
#define StartAndEndColor [UIColor redColor]
#define SelectedColor [UIColor blueColor]


@interface DayCollectionViewCell ()
@property(nonatomic,strong) UILabel *gregorianCalendarLabel;
@property(nonatomic,strong) UILabel *lunarCalendarLabel;
@end
@implementation DayCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.gregorianCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
        self.gregorianCalendarLabel.textAlignment = NSTextAlignmentCenter;
        self.gregorianCalendarLabel.font = [UIFont systemFontOfSize:12];
        self.gregorianCalendarLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.gregorianCalendarLabel];
        
        self.lunarCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height/2)];
        self.lunarCalendarLabel.textAlignment = NSTextAlignmentCenter;
        self.lunarCalendarLabel.font = [UIFont systemFontOfSize:12];
        self.lunarCalendarLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.lunarCalendarLabel];
        
    }
    return self;
}

-(void)setModel:(DayModel *)model{
    _model = model;
    if (model == nil) {
        self.gregorianCalendarLabel.text = @"";
        self.lunarCalendarLabel.text = @"";
        self.backgroundColor = NormalColor;
    }else{
        if (model.isToday) {//是今天
            self.gregorianCalendarLabel.text = @"今天";
            self.lunarCalendarLabel.textColor = [UIColor redColor];
            self.gregorianCalendarLabel.textColor = [UIColor redColor];
            NSString *string = [self getJieJiaRiWithMonth:model.month Day:model.day];
            if (string.length) {
                self.lunarCalendarLabel.text = string;
            }else{
                NSDictionary *lunarDic = [self LunarForSolarYear:(int)model.year Month:(int)model.month Day:(int)model.day];
                NSString *lunarStr = [self lunarWith:lunarDic];
                self.lunarCalendarLabel.text = lunarStr;
            }
        }else{//不是今天
            self.gregorianCalendarLabel.text = [NSString stringWithFormat:@"%02ld",model.day];
            NSString *string = [self getJieJiaRiWithMonth:model.month Day:model.day];
            if (string.length) {//是阳历节日
                self.lunarCalendarLabel.text = string;
                self.lunarCalendarLabel.textColor = [UIColor blueColor];
                self.gregorianCalendarLabel.textColor = [UIColor blueColor];
            }else{
                NSDictionary *lunarDic = [self LunarForSolarYear:(int)model.year Month:(int)model.month Day:(int)model.day];
                NSString *lunarStr = [self lunarWith:lunarDic];
                if ([[lunarDic objectForKey:@"szNongliDay"] isEqualToString:lunarStr] || [[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:lunarStr]) {//不是节日
                    self.lunarCalendarLabel.textColor = [UIColor blackColor];
                    self.gregorianCalendarLabel.textColor = [UIColor blackColor];;
                }else{//是阴历节日
                    self.lunarCalendarLabel.textColor = [UIColor orangeColor];
                    self.gregorianCalendarLabel.textColor = [UIColor orangeColor];
                }
                self.lunarCalendarLabel.text = lunarStr;
            }
        }
        switch (model.state) {
            case DayModelStateNormal:{
                self.backgroundColor = NormalColor;
                break;
            }
            case DayModelStateStart:{
                self.backgroundColor = StartAndEndColor;
                self.lunarCalendarLabel.textColor = [UIColor whiteColor];
                self.gregorianCalendarLabel.text = @"入住";
                self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                break;
            }
            case DayModelStateEnd:{
                self.backgroundColor = StartAndEndColor;
                self.lunarCalendarLabel.textColor = [UIColor whiteColor];
                self.gregorianCalendarLabel.text = @"离店";
                self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                break;
            }
            case DayModelStateSelected:{
                self.backgroundColor = SelectedColor;
                self.lunarCalendarLabel.textColor = [UIColor whiteColor];
                self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                break;
            }
            default:
                break;
                
        }
    }
    
}

#pragma mark - 阳历节日
- (NSString *)getJieJiaRiWithMonth:(NSInteger)month Day:(NSInteger)day{
    if (month == 1 && day == 1) {
        return @"元旦节";
    }
    if (month == 2 && day == 14) {
        return @"情人节";
    }
    if (month == 3 && day == 8) {
        return @"妇女节";
    }
    if (month == 3 && day == 12) {
        return @"植树节";
    }
    if (month == 4 && day == 1) {
        return @"愚人节";
    }
    if (month == 4 && day == 5) {
        return @"清明节";
    }
    if (month == 5 && day == 1) {
        return @"劳动节";
    }
    if (month == 5 && day == 4) {
        return @"青年节";
    }
    if (month == 5 && day == 12) {
        return @"护士节";
    }
    
    if (month == 6 && day == 1) {
        return @"儿童节";
    }
    if (month == 7 && day == 1) {
        return @"建党节";
    }
    if (month == 8 && day == 1) {
        return @"建军节";
    }
    if (month == 9 && day == 10) {
        return @"教师节";
    }
    if (month == 10 && day == 1) {
        return @"国庆节";
    }
    if (month == 11 && day == 11) {
        return @"光棍节";
    }
    if (month == 12 && day == 24) {
        return @"平安夜";
    }
    if (month == 12 && day == 25) {
        return @"圣诞节";
    }
    return nil;
}

#pragma mark - 农历节日
-(NSString *)lunarWith:(NSDictionary *)lunarDic{
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"三十"]) {
        return @"除夕";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"正月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初一"]) {
        return @"春节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"正月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"元宵节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"五月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初五"]) {
        return @"端午节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"七月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初七"]) {
        return @"七夕节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"七月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"中元节";
    }
    
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"八月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"十五"]) {
        return @"中秋节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"九月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初九"]) {
        return @"重阳节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初八"]) {
        return @"腊八节";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"廿三"]) {
        return @"北方小年";
    }
    if ([[lunarDic objectForKey:@"szNongliMonth"] isEqualToString:@"腊月"] && [[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"廿四"]) {
        return @"南方小年";
    }
    
    if ([[lunarDic objectForKey:@"szNongliDay"] isEqualToString:@"初一"]) {
        return [lunarDic objectForKey:@"szNongliMonth"];
    }
    return [lunarDic objectForKey:@"szNongliDay"];
}


-(NSDictionary *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay{
    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",
                          @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",
                          nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"腊月",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    
    nIsEnd = 0;
    
    m = 0;
    
    while(nIsEnd != 1)
        
    {
        
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            
            nBit = wNongliData[m];
            
            for(i=1;i < n+1;i++)
                
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        
        if(nIsEnd)
            
            break;
        
        m = m + 1;
        
    }
    
    wCurYear = 1921 + m;
    
    wCurMonth = k - n + 1;
    
    wCurDay = nTheDate;
    
    if (k == 12)
        
    {
        
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            
            wCurMonth = 1 - wCurMonth;
        
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            
            wCurMonth = wCurMonth - 1;
        
    }
    
    
    //生成农历月
    
    NSString *szNongliMonth;
    
    if (wCurMonth < 1){
        
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
        
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    
    //    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    //    return lunarDate;
    
    NSMutableDictionary *lunarDateDic = [[NSMutableDictionary alloc]init];
    [lunarDateDic setValue:szNongliMonth forKey:@"szNongliMonth"];
    [lunarDateDic setValue:szNongliDay forKey:@"szNongliDay"];
    
    return lunarDateDic;
    
}


@end

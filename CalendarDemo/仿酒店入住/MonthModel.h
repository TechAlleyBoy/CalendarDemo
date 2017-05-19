//
//  MonthModel.h
//  BJTResearch
//
//  Created by yunlong on 17/5/12.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DayModelStateNormal = 0,
    DayModelStateStart,
    DayModelStateEnd,
    DayModelStateSelected,
} DayModelState;




typedef enum : NSUInteger {
    Sunday = 1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
} DayModelOfTheWeek;


@interface DayModel : NSObject

/**
 * 年
 */
@property(nonatomic,assign)NSInteger year;

/**
 * 月
 */
@property(nonatomic,assign)NSInteger month;
/**
 * 日
 */
@property(nonatomic,assign)NSInteger day;

/**
 * 日期
 */
@property(nonatomic,strong)NSDate *dayDate;

/**
 * 星期
 */
@property(nonatomic,assign)DayModelOfTheWeek dayOfTheWeek;

/**
 * 日期的状态
 */
@property(nonatomic,assign)DayModelState state;

/**
 * 日期是不是今天
 */
@property(nonatomic,assign)BOOL isToday;


@end


@interface MonthModel : NSObject
/**
 * 年
 */
@property(nonatomic,assign)NSInteger year;

/**
 * 月
 */
@property(nonatomic,assign)NSInteger month;

/**
 * 一个月中UICollectionViewCell的个数
 */
@property(nonatomic,assign)NSInteger cellNum;

/**
 * 月UITableViewCell的高度
 */
@property(nonatomic,assign)CGFloat cellHight;

/**
 * UICollectionViewCell开始的位置
 */
@property(nonatomic,assign)NSInteger cellStartNum;
/**
 * 月UITableViewCell的高度
 */
@property(nonatomic,strong)NSArray<DayModel *> * days;
@end

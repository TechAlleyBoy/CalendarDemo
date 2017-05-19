//
//  HotelCalendarViewController.h
//  BJTResearch
//
//  Created by yunlong on 17/5/11.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCalendarViewController : UIViewController
@property(nonatomic,copy) void(^selectCheckDateBlock)(NSString *startDate,NSString *endDate,NSString *days);
@end

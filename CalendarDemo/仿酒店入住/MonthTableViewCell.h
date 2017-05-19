//
//  MonthTableViewCell.h
//  BJTResearch
//
//  Created by yunlong on 17/5/12.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthModel,DayModel;
typedef void(^SelectedDay)(DayModel *returnDaymodel);
@interface MonthTableViewCell : UITableViewCell
@property(nonatomic,strong) MonthModel *model;
@property(nonatomic,copy)SelectedDay selectedDay;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

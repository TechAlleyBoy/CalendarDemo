
//
//  MonthTableViewCell.m
//  BJTResearch
//
//  Created by yunlong on 17/5/12.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "MonthTableViewCell.h"
#import "MonthModel.h"
#import "DayCollectionViewCell.h"

@interface MonthTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *dateLabel;
@end
@implementation MonthTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *CellID = @"MonthTableViewCellID";
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell==nil) {
        cell = [[MonthTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellID];
        
    }
    cell.userInteractionEnabled = YES;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setContentView];
    }
    return self;
}

- (void)setContentView{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 9)];
    lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self.contentView addSubview:lineView];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 48  )];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:_dateLabel];
    [self.contentView addSubview:self.collectionView];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        flowLayout.itemSize =  CGSizeMake(([UIScreen mainScreen].bounds.size.width - 16)/7, 60);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 500) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        [_collectionView registerClass:[DayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCellID"];
        
    }
    return _collectionView;
}


#pragma mark - 设置内容
- (void)setModel:(MonthModel *)model{
    _model = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.collectionView.frame;
        frame.size.height = model.cellHight - 60;
        self.collectionView.frame = frame;
    });
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%02ld月",model.year ,model.month];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _model.cellNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCollectionViewCellID" forIndexPath:indexPath];
    
    if ((indexPath.row < _model.cellStartNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        cell.model = nil;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        cell.model = model;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row < _model.cellStartNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        return;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        if (self.selectedDay) {
            self.selectedDay(model);
        }
    }
    
}

@end

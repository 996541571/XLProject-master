//
//  NLCollectionViewCell.m
//  XXProjectNew
//
//  Created by apple on 11/25/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NLCollectionViewCell.h"
#import "NLTableView.h"
@implementation NLCollectionViewCell


//只走一遍

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}


-(void)setup{
    
    
    NLTableView* table = [NLTableView new];
    
    self.tableView = table;
    
    [self.contentView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
        
    }];

    //注册cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NLTableViewCell" bundle:nil] forCellReuseIdentifier:NLTableViewReusedID];
    
    
    //其他设置
    
    
    self.tableView.backgroundColor = gray_backgound;

    
    
}


@end

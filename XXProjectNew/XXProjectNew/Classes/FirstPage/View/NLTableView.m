//
//  NLTableView.m
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NLTableView.h"
#import "NewsListPageViewModel.h"
@interface NLTableView()
@property(nonatomic,assign)NSInteger currentPage;
@end

@implementation NLTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
        
        self.currentPage = 2;
        
    }
    return self;
}



-(void)setup{
    
    self.tableFooterView = [UIView new];
    
    self.estimatedRowHeight = 2;
    
    self.rowHeight = UITableViewAutomaticDimension;
    
    
    self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 10)];
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.bounces = NO;
    
    
    // 下拉加载
    
    
    __weak typeof(self) weakSelf = self;
    
    [self addFooterWithCallback:^{
       
        
//        [[NewsListPageViewModel model] obtainWebDataWithType:weakSelf.tag andFinished:^{
//            
//            
//            [weakSelf footerEndRefreshing];
//            
//            [weakSelf reloadData];
//        }];
        
                [[NewsListPageViewModel model] obtainWebDataWithType:weakSelf.tag andCurrentPage:@(weakSelf.currentPage) andFinished:^{
                    
                    
                    [weakSelf footerEndRefreshing];
                    
                    if (weakSelf.currentPage >8) {
                        return ;
                    }
                    
                    [weakSelf reloadData];
                    weakSelf.currentPage++;
                    
                }];
        
        
        
    }];
    
    
    
    
    
}


@end

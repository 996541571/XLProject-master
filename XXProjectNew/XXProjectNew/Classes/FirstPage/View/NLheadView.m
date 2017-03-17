//
//  NLheadView.m
//  XXProjectNew
//
//  Created by apple on 11/24/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "NLheadView.h"
#import "NewsListPageViewModel.h"
@interface NLheadView()

@property(nonatomic,weak)UIButton* selected_btn;

@end


@implementation NLheadView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    
    NSArray* arr = @[@"热门资讯",@"健康资讯",@"时尚潮流",@"娱乐新闻"];
    
    self.backgroundColor = [UIColor whiteColor];
    
#define btnWidth (screenWidth/4.0)
#define btnHeight 40

    
    float xPlaceHolder = (screenWidth  - btnWidth*arr.count)/(arr.count+1);
    
    
    CGFloat space = (headViewHight - btnHeight)/2;
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (int i = 0 ; i < arr.count ; i++) {
        
        
        UIButton* btn = [UIButton new];
        
        //计算frame
        //宽 = 左右边距 + 图标宽*数量+图标之间的间隙(数量+1)
        
        btn.frame=CGRectMake(xPlaceHolder+(btnWidth+xPlaceHolder)*i,space, btnWidth, btnHeight);
        
        [self addSubview:btn];
        
        btn.tag = i;
        
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:title_Color forState:UIControlStateNormal];
        
        [btn setTitleColor:title_redColor forState:UIControlStateSelected];
        
        [btn setTitleColor:title_redColor forState:UIControlStateSelected | UIControlStateHighlighted];
        
        
        btn.titleLabel.font = [UIFont systemFontOfSize:text_Size+1];
        

        [array addObject:btn];
        
        
        
        
    }
    
    
    self.btnArr = array.copy;
    
    [self viewDidScroll:self.btnArr[0]];
    
    
}


-(void)btnDidClick:(UIButton*)btn{
//    
    self.selected_btn.highlighted = NO;
//
    if (self.selected_btn == btn) {
        
        return ;
    }
    
    
    
    if (self.block) {
        
        self.block(btn.tag);
    }
    
    
    
    
}



-(void)viewDidScroll:(UIButton*)btn{
    
    self.selected_btn.highlighted = NO;
    
    if (self.selected_btn == btn) {
        
        return ;
        
    }else{
        
        
        
        // 友盟统计
        
        NSArray* arr = @[@"um_main_news_more_first_rmzx_click_event",
                         @"um_main_news_more_first_jkzx_click_event",
                         @"um_main_news_more_first_sscl_click_event",
                         @"um_main_news_more_first_ylxw_click_event"];
        
        [MobClick event:arr[btn.tag]];
        
        NSLog(@"%td----%@",btn.tag,arr[btn.tag]);

        
        btn.selected = YES;
        
        self.selected_btn.selected = NO;
        
        self.selected_btn = btn;
        
    }
    
    
}

@end

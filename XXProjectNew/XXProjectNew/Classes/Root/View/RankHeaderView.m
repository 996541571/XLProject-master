//
//  RankHeaderView.m
//  XXProjectNew
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "RankHeaderView.h"

@implementation RankHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame labelNameStr:(NSString*)labelName imageNameStr:(NSString*)imagenameStr section:(NSInteger)section
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel*backLabel=[[UILabel alloc]init];
        
        backLabel.frame=CGRectMake(0, 0, screenWidth, self.frame.size.height/7);
        
        backLabel.backgroundColor=RGB(238, 238, 238, 1);


        [self addSubview:backLabel];

        
        UIImageView*headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/7, screenWidth, self.frame.size.height*6/7)];
        headImg.image=[UIImage imageNamed:imagenameStr];
        [self addSubview:headImg];
        CGPoint viewPoint=headImg.center;
        UILabel*label=[[UILabel alloc]init];
        label.text=labelName;
        
        label.frame=CGRectMake(screenWidth/2-33, viewPoint.y-8, 66, 18);
        label.font=[UIFont systemFontOfSize:16];
        label.textAlignment=NSTextAlignmentCenter;
        
        
        label.textColor=RGB(51, 51, 51, 1);
        [self addSubview:label];

        
        
        
        
        
        
    }
    return self;
}


@end

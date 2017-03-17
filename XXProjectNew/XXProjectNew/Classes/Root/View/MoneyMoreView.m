//
//  MoneyMoreView.m
//  XXProjectNew
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "MoneyMoreView.h"

@implementation MoneyMoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=RGB(247, 232, 247, 1);
                CGPoint viewPoint=self.center;
        UIImageView*arrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(16, viewPoint.y-9, 20, 18)];
        arrowImgView.image=[UIImage imageNamed:@"introduce"];
        [self addSubview:arrowImgView];

        UILabel*label=[[UILabel alloc]init];
        
        label.textColor = RGB(128, 85, 128, 1);
        
        label.text=@"显示收益为0时，并不代表真实收益为0，有可能是收益还未导入系统";
        label.numberOfLines=0;
//        if ([UIScreen mainScreen].bounds.size.height < 560.0) {
//            label.font=[UIFont systemFontOfSize:12];
//        }else if ([UIScreen mainScreen].bounds.size.height == 568.0) {
//            label.font=[UIFont systemFontOfSize:12];
//        }else if ([UIScreen mainScreen].bounds.size.height == 667.0) {
//            label.font=[UIFont systemFontOfSize:13];
//        }else if ([UIScreen mainScreen].bounds.size.height == 736.0) {
//            label.font=[UIFont systemFontOfSize:16];
//        }
        label.font=[UIFont systemFontOfSize:12];
        label.lineBreakMode=NSLineBreakByWordWrapping;
//        label.textAlignment=NSTextAlignmentCenter;
        CGSize size=CGSizeMake(0.8*screenWidth, 4);
        CGSize expectSize=[label sizeThatFits:size];
//        label.textColor=RGB(47, 150, 255, 1);
        label.frame=CGRectMake(0.144*screenWidth, (self.bounds.size.height - expectSize.height)/2, expectSize.width, expectSize.height);
//        label.frame=CGRectMake(0.144*screenWidth, 0.179*frame.size.height, expectSize.width, expectSize.height);

        [self addSubview:label];
        
        
    }
    return self;
}


@end

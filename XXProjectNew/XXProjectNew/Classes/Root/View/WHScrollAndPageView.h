//
//  aView.h
//  scrollview无限滑动
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 108mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WHcrollViewViewDelegate;


@interface WHScrollAndPageView : UIView<UIScrollViewDelegate>
{
    __unsafe_unretained id <WHcrollViewViewDelegate> _delegate;

    UIScrollView* _scrollView;
    UIPageControl*_page;
    NSTimer*_timer;
    int _speed;
    NSMutableArray*_picArr;
    NSMutableArray*_usefulPicArr;
    int currentPage;
    int totalPage;
    UITapGestureRecognizer *_tap;
    
}
@property (nonatomic, assign) id <WHcrollViewViewDelegate> delegate;

@end
@protocol WHcrollViewViewDelegate <NSObject>

@optional
- (void)didClickPage:(WHScrollAndPageView *)view atIndex:(NSInteger)index;




@end

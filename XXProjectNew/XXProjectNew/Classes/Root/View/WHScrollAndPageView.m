//
//  aView.m
//  scrollview无限滑动
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 108mac. All rights reserved.
//

#import "WHScrollAndPageView.h"
#define width     [UIScreen mainScreen].bounds.size.width
#define height     [UIScreen mainScreen].bounds.size.height

@implementation WHScrollAndPageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        totalPage=1;
        _picArr=[[NSMutableArray alloc]init];
        _usefulPicArr= [[NSMutableArray alloc]init];
        
        
        
        for (int i=0; i<totalPage; i++) {
//                    UIImage*image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://h5-dev.xianglin.cn/image/banner/banner_home_new.png?v=20160826"]]];
            UIImage*image=[UIImage imageNamed:[NSString stringWithFormat:@"image%d",i]];
            [_picArr addObject:image];
        }
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.delegate=self;
        _scrollView.frame=self.frame;
        [_scrollView setContentSize:CGSizeMake(3*width, height)];
        [self addSubview:_scrollView];
        _page=[[UIPageControl alloc]init];
        _page.center=CGPointMake(width/2, 500);
        _page.numberOfPages=totalPage;
        _page.pageIndicatorTintColor=[UIColor greenColor];
        _page.currentPageIndicatorTintColor=[UIColor redColor];
        [self  addSubview:_page];
        currentPage=0;
        
        [self refreshScrollView];
        
        //if(_timer == nil)
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(move11) userInfo:nil repeats:YES];
        

        
               
    }
    return self;
}
-(void)refreshScrollView
{
    int pre;
    int last;
    pre=currentPage-1;
    last=currentPage+1;
    if (currentPage==0) {
        pre=totalPage-1;
    }
    if (currentPage==totalPage-1) {
        last=0;
    }
    
    if (_usefulPicArr.count!=0) {
        [_usefulPicArr removeAllObjects];
    }
    [_usefulPicArr addObject:[_picArr objectAtIndex:pre]];
    [_usefulPicArr addObject:[_picArr objectAtIndex:currentPage]];
    [_usefulPicArr addObject:[_picArr objectAtIndex:last]];
    for (int i=0; i<3; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image=_usefulPicArr[i];
        imageView.frame=CGRectOffset(self.frame, width*i, 0);
        [_scrollView addSubview:imageView];
        //设置单击手势
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        _tap.numberOfTapsRequired = 1;
        _tap.numberOfTouchesRequired = 1;
        [_scrollView addGestureRecognizer:_tap];
      
    }
    [_scrollView setContentOffset:CGPointMake(width, 0)];
    
    
    
    
}

-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:currentPage+1];
    }
}


-(void)btnPress:(UIButton*)sender
{
    NSLog(@"------%ld",(long)sender.tag);
}

-(void)move11
{       [_scrollView scrollRectToVisible:CGRectMake(width * 2, 0, width, height) animated:YES];
    
    if (currentPage == totalPage-1) {
        [_page setCurrentPage:0];
    }
    else
    {
        [_page setCurrentPage:currentPage+1];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x==2*width) {
        if (currentPage==totalPage-1) {
            currentPage=0;
        }else
        {
            currentPage=currentPage+1;
        }
        int pre;
        int last;
        pre=currentPage-1;
        last=currentPage+1;
        if (currentPage==0) {
            pre=totalPage-1;
        }
        if (currentPage==totalPage-1) {
            last=0;
        }
        
        if (_usefulPicArr.count!=0) {
            [_usefulPicArr removeAllObjects];
        }
        [_usefulPicArr addObject:[_picArr objectAtIndex:pre]];
        [_usefulPicArr addObject:[_picArr objectAtIndex:currentPage]];
        [_usefulPicArr addObject:[_picArr objectAtIndex:last]];
        for (int i=0; i<3; i++) {
            UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
            imageView.image=_usefulPicArr[i];
            imageView.frame=CGRectOffset(self.frame, width*i, 0);
            [_scrollView addSubview:imageView];
            
            
        }
        [_scrollView setContentOffset:CGPointMake(width, 0)];
        
        
        
        
        
    }
    
    
}


@end

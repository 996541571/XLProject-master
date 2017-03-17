#import "RoundView.h"

@implementation RoundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
     
    }
    return self;
}

-(void)noNetWork:(CGRect)rect
{
    CGContextRef   context = UIGraphicsGetCurrentContext();
    
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 255/255.0, 106/255.0, 0/255.0, 1);
    
    CGContextAddArc(context, rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2-10, rect.size.width/3.9, -M_PI, M_PI, 0);
    [[UIColor lightGrayColor] set];
    
    
    
    
    
    CGContextSetLineWidth(context, 0.135*rect.size.width/3.9);
    
    
    CGContextDrawPath(context, kCGPathStroke);

    
}

- (void)drawRect:(CGRect)rect
{
    /*画填充圆
     */
    NSMutableArray*dataArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"transferDataArr"];
    NSMutableArray*labNameArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"labNameArr"];
    float totol = 0.f;
    float total = 0.f;
    for (int i = 0; i < dataArr.count; i++) {
        total += [dataArr[i] floatValue];
    }
    totol = [[NSString stringWithFormat:@"%.2f",total] floatValue];
    NSLog(@"------------wangluo====%d",[CoreStatus isNetworkEnable]);
    if (![CoreStatus isNetworkEnable]) {
        CGContextRef context;
        [self aaa:rect index:0 context:context begin:0 end:1 color:RGB(240, 240, 240, 1)];
        
    }else if (dataArr==nil||labNameArr==nil)
    {
        CGContextRef context;
        [self aaa:rect index:0 context:context begin:0 end:1 color:RGB(240, 240, 240, 1)];
    }else if (totol == 0){
        CGContextRef context;
        [self aaa:rect index:0 context:context begin:0 end:1 color:RGB(240, 240, 240, 1)];
    }
    else
    {

        
        if (dataArr.count==4) {
            
            for (int i=0; i<dataArr.count; i++)
            {
            if (i==0) {
                CGContextRef context0;
                UIColor*color;
                [self aaa:rect index:0 context:context0 begin:0 end:[dataArr[0] floatValue]/totol  color:color ];
                      }
           else if (i==1) {
               UIColor*color;
        

            CGContextRef context1;
            [self aaa:rect index:1 context:context1 begin:[dataArr[0] floatValue]/totol end:([dataArr[0] floatValue]+[dataArr[1] floatValue])/totol  color:color];
                                
                      }
           else if (i==2) {
               CGContextRef context2;
               UIColor*color;
               


               [self aaa:rect index:2 context:context2 begin:([dataArr[0] floatValue]+[dataArr[1] floatValue])/totol end:([dataArr[0] floatValue]+[dataArr[1] floatValue]+[dataArr[2]floatValue])/totol color:color];
           }else {
                   CGContextRef context3;
               UIColor*color;
               
               if ([labNameArr[3] isEqualToString:@"银行"]) {
                   color=RGB(156, 207, 253, 1);
                   
                   
                   
               }else if ([labNameArr[3] isEqualToString:@"电商"])
               {
                   color=RGB(255, 166, 165, 1);
                   
                   
               }else if ([labNameArr[3] isEqualToString:@"话费"])
               {
                   
                   color=RGB(255, 237, 184, 1);
                   
               }else{
                   color=RGB(186, 244, 227, 1);
                   
               }

                   [self aaa:rect index:3 context:context3 begin:([dataArr[0] floatValue]+[dataArr[1] floatValue]+[dataArr[2]floatValue])/totol end:1 color:color];
                }

               
           }
        }else if(dataArr.count==3)
        {
            
            for (int i=0; i<dataArr.count; i++)
            {
                if (i==0) {
                    CGContextRef context0;
                    UIColor*color;
                    
                    if ([labNameArr[0] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);
                        
                        
                        
                    }else if ([labNameArr[0] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
                        
                        
                    }else if ([labNameArr[0] isEqualToString:@"话费"])
                    {
                        
                        color=RGB(255, 237, 184, 1);
                        
                    }else{
                        color=RGB(186, 244, 227, 1);
                        
                    }
                    
                    [self aaa:rect index:0 context:context0 begin:0 end:[dataArr[0] floatValue]/totol color:color ];

                }
                else if (i==1) {
                    UIColor*color;
                    if ([labNameArr[1] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);
                        
                        
                        
                    }else if ([labNameArr[1] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
                        
                        
                    }else if ([labNameArr[1] isEqualToString:@"话费"])
                    {
                        
                        color=RGB(255, 237, 184, 1);
                        
                    }else{
                        color=RGB(186, 244, 227, 1);
                        
                    }
                    
                    CGContextRef context1;
                    [self aaa:rect index:1 context:context1 begin:[dataArr[0] floatValue]/totol end:([dataArr[0] floatValue]+[dataArr[1] floatValue])/totol  color:color];
//

                    
                }
                else  {
                    CGContextRef context2;
                    UIColor*color;
                    if ([labNameArr[2] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);
                        
                        
                        
                    }else if ([labNameArr[2] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
                        
//
                    }else if ([labNameArr[2] isEqualToString:@"话费"])
                    {
                        
                        color=RGB(255, 237, 184, 1);
                        
                    }else{
                        color=RGB(186, 244, 227, 1);
                        
                    }
                    NSLog(@"%f-%f-%f",([dataArr[0] floatValue]+[dataArr[1] floatValue])/totol,[dataArr[0] floatValue],[dataArr[1] floatValue]);
                    [self aaa:rect index:2 context:context2 begin:([dataArr[0] floatValue]+[dataArr[1] floatValue])/totol end:1 color:color];
                }
            }


        }else if(dataArr.count==2)
        {
            
                   
            for (int i=0; i<dataArr.count; i++)
            {
                if (i==0) {
                    CGContextRef context0;
                    UIColor*color;

                    if ([labNameArr[0] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);

                        
                        
                    }else if ([labNameArr[0] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
//

                    }else if ([labNameArr[0] isEqualToString:@"话费"])
                    {

                        color=RGB(255, 237, 184, 1);

                    }else{
                        color=RGB(186, 244, 227, 1);
//
                    }
                    [self aaa:rect index:0 context:context0 begin:0 end:[dataArr[0] floatValue]/totol color:color];

                }
                else  {
                    
                    CGContextRef context1;
                    UIColor*color;
                    if ([labNameArr[1] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);
                        
                        
                        
                    }else if ([labNameArr[1] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
                        
                        
                    }else if ([labNameArr[1] isEqualToString:@"话费"])
                    {
                        
                        color=RGB(255, 237, 184, 1);
                        
                    }else{
                        color=RGB(186, 244, 227, 1);
                        
                    }

                    [self aaa:rect index:1 context:context1 begin:[dataArr[0] floatValue]/totol  end:1 color:color];
                    
                }
            }

        }else
        {
            for (int i=0; i<dataArr.count; i++)
            {
                if (i==0) {
                    CGContextRef context0;
                    UIColor*color;
            
                    if ([labNameArr[0] isEqualToString:@"银行"]) {
                        color=RGB(156, 207, 253, 1);
                        
                        
                        
                    }else if ([labNameArr[0] isEqualToString:@"电商"])
                    {
                        color=RGB(255, 166, 165, 1);
                        
                        
                    }else if ([labNameArr[0] isEqualToString:@"话费"])
                    {
                        
                        color=RGB(255, 237, 184, 1);
                        
                    }else{
                        color=RGB(186, 244, 227, 1);
                        
                    }
                    [self aaa:rect index:0 context:context0 begin:0 end:1 color:color];

                }
            }

            
        }
    }
    
}
-(void)aaa:(CGRect)rect index:(int)index context:(CGContextRef)context begin:(float)begin end:(float)end color:(UIColor*)color

{
     context = UIGraphicsGetCurrentContext();
    
    
    
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 255/255.0, 106/255.0, 0/255.0, 1);
//    NSMutableArray*dataArr=[[NSUserDefaults standardUserDefaults]objectForKey:@"dataArr"];
//    if (dataArr.count==4) {
//        
//    }
//
//    if (index==0) {
        CGContextAddArc(context, rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2, rect.size.height/2-10, begin*M_PI*2, end*M_PI*2, 0);
        [color set];


//    }else if (index==1)
//    {
//        CGContextAddArc(context, rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2-10, rect.size.width/3.9, begin*M_PI*2, M_PI*2, 0);
//        [color set];
//
//
//    }
    CGContextSetLineWidth(context, 0.27*(rect.size.height/2-10));
    
    
    CGContextDrawPath(context, kCGPathStroke);

}



@end

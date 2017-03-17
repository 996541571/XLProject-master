//
//  XLPackage.m
//  XXProject
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 xianglin. All rights reserved.
//

#import "XLPlist.h"
@interface XLPlist()
@property(nonatomic,strong)dispatch_source_t timer;
@end
@implementation XLPlist
static XLPlist *_instance;
+(instancetype)sharePlist
{
    @synchronized(self){
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
-(id)copyWithZone:(struct _NSZone *)zone{
    return _instance;
}
//plist文件路径
-(NSString*)getPlistRouteByPlistRoute:(NSString*)appendPlistRoute
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filePah=[path stringByAppendingPathComponent:appendPlistRoute];
    return filePah;
}
// 保存plist文件
-(void)saveToPlistByAppendPlisRouteStr:(NSString*)appendPlistRoute ByJsonDic:(id)jsonDic
{
//    NSData*jsonData=[jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary*jsonDic=[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
   
    [jsonDic writeToFile:[self getPlistRouteByPlistRoute:appendPlistRoute] atomically:YES];
}
//读取plist文件
-(NSDictionary*)getPlistDicByAppendPlistRoute:(NSString*)appendPlistRoute
{
    NSDictionary*dic=[NSDictionary dictionaryWithContentsOfFile:[self getPlistRouteByPlistRoute:appendPlistRoute]];
    return dic;
}
// 根据路径删除plist文件
-(void)deletePlistByPlistRoute:(NSString*)appendPlistRoute
{
    
    NSFileManager *manger=[NSFileManager defaultManager];
    [manger removeItemAtPath:[self getPlistRouteByPlistRoute:appendPlistRoute] error:nil];
}

-(void)setObject:(NSObject *)obj forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
-(void)removeObjectForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSDictionary*)deviceInfo
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"did"]) {
        return  @{@"platform":iPhonePlatform,@"systemType":PhoneType,@"systemVersion":iPhoneVersion,@"deviceId":[[NSUserDefaults standardUserDefaults]objectForKey:@"did"]};;
    }else{
        return  @{@"platform":iPhonePlatform,@"systemType":PhoneType,@"systemVersion":iPhoneVersion,@"deviceId":@""};;
    }
    
}
//
- (void)getAuthcode
{
    //字符串素材
   NSArray* dataArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
   NSString* authCodeStr = [[NSMutableString alloc] initWithCapacity:kCharCount];
    //随机从数组中选取需要个数的字符串，拼接为验证码字符串
    for (int i = 0; i < kCharCount; i++)
    {
        NSInteger index = arc4random() % (dataArray.count-1);
        NSString *tempStr = [dataArray objectAtIndex:index];
        authCodeStr = (NSMutableString *)[authCodeStr stringByAppendingString:tempStr];
    }
}
-(void)reGetIdentityCode:(UIButton*)btn
{
    __block int timeout=60;//倒计时时间
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0,queue);
    _timer = timer;
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0),1.0*NSEC_PER_SEC,0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){//倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示根据自己需求设置
                
                [btn setTitle:@"获取验证码"forState:UIControlStateNormal];
                
                btn.userInteractionEnabled =YES;
                
                btn.backgroundColor = [UIColor clearColor];
                
            });
            
        }else{
            
            int seconds = timeout;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //让按钮变为不可点击的灰色
                
//                btn.backgroundColor = [UIColor grayColor];
                
                btn.userInteractionEnabled =NO;
                
                //设置界面的按钮显示根据自己需求设置
                
                [UIView beginAnimations:nil context:nil];
                
                [UIView setAnimationDuration:1];
                
                [btn setTitle:[NSString stringWithFormat:@"%@秒后重新获取",strTime]forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
    

}

-(void)cancelTimerOfButton:(UIButton *)btn
{
    dispatch_source_cancel(_timer);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //设置界面的按钮显示根据自己需求设置
        
        [btn setTitle:@"获取验证码"forState:UIControlStateNormal];
        
        btn.userInteractionEnabled =YES;
        
        btn.backgroundColor = [UIColor clearColor];
        
    });

}
@end


//
//  StationAgentViewModel.m
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "StationAgentViewModel.h"
#import "StationAgentModel.h"
@interface StationAgentViewModel()

@end

@implementation StationAgentViewModel

+(instancetype)model{
    
    static id model;
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        model = [StationAgentViewModel new];
        
    });
    
    return model;
}


-(void)obtainWebDataWithSuccess:(void (^)())success andFinished:(void(^)())finished{
    
    
/*

 get partyId

 */

    
    
//    NSDictionary*proactiveLoginDic= [[XLPlist sharePlist] getPlistDicByAppendPlistRoute:proactiveLogin];
    //    NSString *nodePartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodePartyId"]];
    
//    NSString *nodeManagerPartyId=[NSString stringWithFormat:@"%@",proactiveLoginDic[@"nodeManagerPartyId"]];
    
    
//    NSArray* arr = @[nodeManagerPartyId];
    
    //@"app.PersonInfoService.getPersonInfo"
    //@"UserService.getUserInfo"
    
    
    
    
    NSString* requestName = @"UserService.getUserInfo";
    
    NSDictionary* dic = @{};
    
    [NetRequest requetWithParams:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        //如果报错
        if (error) {
            NSLog(@"%@",error);           
            return ;
        }
                
        NSLog(@"%@",responseDicionary);
        
        
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
            
            NSDictionary* dic = [responseDicionary valueForKey:@"result"];
            
//            [[XLPlist sharePlist]setObject:dic forKey:@"UserInfo"];
            
            //------------------------------------------------------------------------------
            
            //处理数据 防止数据为空-----已经在模型中做了
            
            
            self.dataModel = [StationAgentModel new];
            
            [self.dataModel setValuesForKeysWithDictionary:dic];
            
            self.dataModel_arr = @[self.dataModel.name,
                                   self.dataModel.sex,
                                   self.dataModel.loginName,
                                   self.dataModel.idNumber,
                                   self.dataModel.followsNumber,
                                   self.dataModel.fansNumber
                                   ];
            
            
            
            
            //------------------------------------------------------------------------------
            
            
            self.partyId = [[responseDicionary valueForKey:@"result"] valueForKey:@"partyId"];
            
            //------
            
            
            self.dataArr =  [self dealWithData:@[@"trueName",@"userRole",@"gender",@"credentialsNumber",@"mobilePhone",@"wechatId"] andDic:dic];
            
            //            NSArray* arr = [dic valueForKey: @"logComments"];
            //
            //            self.logArr = [[arr reverseObjectEnumerator] allObjects];
            
            self.logArr = [dic valueForKey: @"logComments"];

            
            
            NSString* partyId = self.partyId;
            
            if (!self.partyId) {
                
                
                partyId = @"";
            }
            
            
            //显示余额 
            
            [NetRequest requetWithParams:@[partyId] requestName:@"app.PersonInfoService.isShowAccountTips" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
                
                NSLog(@"%@",responseDicionary);
                
                
                if ([[responseDicionary valueForKey:@"resultStatus"] integerValue] == 1000) {
                    
                    
                    
                    if ([responseDicionary valueForKey:@"result"]) {
                        
                        //如果有字典--显示
                        
                        
                        self.coinAppear = YES;
                        
                    }else{
                        
                        //如果字典不存在--不显示
                        
                        self.coinAppear = NO;
                        
                    }
                    
                    
                    if(success){
                        
                        success();
                    }

                }
                
            }];

            
            
            
            if(success){
                
                success();
            }
            
            
            
        }
        
        
        
    }];
    
    
    
    
    if(finished){
        
        finished();
    }

    #pragma mark  test
    
    [self test];
}

-(NSArray*)dealWithData : (NSArray<NSString*>*)strArr andDic:(NSDictionary*)dic{
    
    NSMutableArray* arr =  [NSMutableArray array] ;
    
    for (NSString* str  in strArr) {
        
        if ([[dic valueForKey:str] length]) {
            
            [arr addObject: [dic valueForKey:str]];
            
            
        }else{
            
            if ([str isEqualToString:@"userRole"]) {
                
                [arr addObject:@"站长"];
                
            }else{
                
                [arr addObject:@"暂无数据"];
            }
            
            
        }
        
        
    }
    
    
    return arr.copy;
    
}


-(void)uploadForHeadIcon:(UIImage*)img Success:(void(^)(NSString* imgUrl))success{
    
    NSString* requestName = @"UserService.uploadImg";
    
//    NSData* data = UIImagePNGRepresentation(img);
    
    NSData* data = UIImageJPEGRepresentation(img,0.4);

    
    
    
    NSString* imgStr = [XLEncryptionManager base64EncryptionWithData:data];
    
    
    //该函数将 将要添加到URL的字符串进行特殊处理，如果这些字符串含有 &， ？ 这些特殊字符，用“%+ASCII” 代替之。
    
    //NSString *baseString = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)imgStr,NULL,CFSTR(":/?#[]@!$&’()*+,;="),kCFStringEncodingUTF8);

    
    NSDictionary* dic = @{@"imgBusiType":@"USER_HEAD_IMG",@"base64Img":imgStr};

    
    //data	NSConcreteMutableData *	558228 bytes	0x0000600000642910
    
    [NetRequest requetWith_img_Params:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        //如果报错
        if (error) {
            NSLog(@"%@",error);
            return ;
        }
        
        
        NSLog(@"%@",responseDicionary);
        
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
            
            NSString* img_url = [responseDicionary valueForKey:@"result"];
            
            
            if (success) {
                success(img_url);
            }
            
        }
        
    }];
    
    
    // de_base64_test
    
//   NSData* de_data =  [XLEncryptionManager base64DecryptionWithString:imgStr];
//    
//    UIImage* de_img = [UIImage imageWithData:de_data];
//    
//    UIImageView* de_imgV = [[UIImageView alloc]initWithImage:de_img];
//    
//    [[UIApplication sharedApplication].keyWindow addSubview:de_imgV];
//    
//    
//    [de_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.center.equalTo([UIApplication sharedApplication].keyWindow);
//    }];

    
}

-(void)saveAndUpdataWithType:(Type)type para:(NSString*)str andSuccess:(void (^)(BOOL success))block{
    
    //    更新用户信息	 com.xianglin.appserv.common.service.facade.UserService.updateUserInfo
    //    入参：
    //    需要更新的参数 非必填
    //    //昵称
    //    nikerName;
    //    //一句话介绍
    //    introduce;
    //    出参：
    //    {"id":0,"result":"","resultStatus":1000}

    
    NSDictionary* dic;
    
    if (type == TypeNickname) {
        
        dic = @{@"nikerName":str};
        
    }else if (type == TypeIntroduce){
        
        dic = @{@"introduce":str};
        
    }else if(type == TypeGender){
        
        dic = @{@"sex":str};
        
    }
    
    NSString* requestName = @"UserService.updateUserInfo";
    
    
    
    [NetRequest requetWithParams:@[dic] requestName:requestName finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
        
        //如果报错
        if (error) {
            NSLog(@"%@",error);
            if (block) {
                block(NO);
            }
            return ;
        }
        
        
        NSLog(@"%@",responseDicionary);
        
        
        if ([[responseDicionary valueForKeyPath:@"resultStatus"] integerValue] == 1000) {
            
            
//            
            if (block) {
                block(YES);
            }
            
        }else{
            
            if (block) {
                block(NO);
            }

            
        }
        
    }];

    
    
}

-(void)test{
    
    
    //com.xianglin.appserv.common.service.facade.app.PersonInfoService.getRowInfo
    
//    
//    [NetRequest requetWithParams:@[] requestName:@"app.PersonInfoService.getRowInfo" finishBlock:^(NSDictionary *responseDicionary, NSError *error) {
//   
//    NSLog(@"%@",responseDicionary);
//    
//}];
    
    
    
    
    
}




@end

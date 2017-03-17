//
//  StationAgentModel.m
//  XXProjectNew
//
//  Created by apple on 11/29/16.
//  Copyright © 2016 xianglin. All rights reserved.
//

#import "StationAgentModel.h"

@implementation StationAgentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

}


-(NSString*)idNumber{
    
    if (!_idNumber || !_idNumber.length) {
        
        
        
        _idNumber = @"";
        
    }else{
        
        
        
        NSString* str = _idNumber.copy;
        
        str =  [str substringToIndex:8];
        
        str = [NSString stringWithFormat:@"%@******",str];

        
        _idNumber = str;
        
        
        
        
    }
    
    
    return _idNumber;
}

-(NSString*)name{
    
    if (!_name) {
        
        _name = @"";
        
    }
    
    
    return _name;
}

-(NSString*)sex{
    
    if (!_sex) {
        
        _sex = @"请设置性别";
        
    }
    
    
    return _sex;
}

-(NSString*)mobilePhone{
    
    if (!_mobilePhone || !_mobilePhone.length) {
        
        _mobilePhone = @"";
        
    }
    
    
    return _mobilePhone;
}

-(NSString*)nikerName{
    
    if (!_nikerName || !_nikerName.length) {
        
        _nikerName = @"请设置昵称";
        
    }
    
    
    return _nikerName;
}

-(NSString*)introduce{
    
    if (!_introduce || !_introduce.length) {
        
        _introduce = @"用一句话来介绍你自己";
        
    }
    
    
    return _introduce;
}

//-(NSString*)headImg{
//    
//    if (!_headImg) {
//        
//        _headImg = @"暂无数据";
//        
//    }
//    
//    
//    return _credentialsNumber;
//}




@end

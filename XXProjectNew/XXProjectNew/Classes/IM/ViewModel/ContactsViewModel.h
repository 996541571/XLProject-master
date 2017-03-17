//
//  ContactsViewModel.h
//  XXProjectNew
//
//  Created by apple on 2017/1/5.
//  Copyright © 2017年 xianglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsViewModel : NSObject
@property(nonatomic,strong)NSMutableArray *sectionTitles;

+(instancetype)shareModel;

-(void)getContactsDataWithBlock:(void(^)(NSArray *contacts))block;
-(NSArray *)setUpTableSectionWithContacts:(NSArray *)contacts;
@end

//
//  JMUserModel.h
//  JMBaseProject
//
//  Created by Liuny on 2020/1/3.
//  Copyright © 2020 liuny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMUserModel : NSObject

@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *name;//昵称
@property (nonatomic, copy) NSString *headUrl;//头像

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END

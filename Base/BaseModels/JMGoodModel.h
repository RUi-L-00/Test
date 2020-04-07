//
//  JMGoodModel.h
//  JMBaseProject
//
//  Created by Liuny on 2020/1/3.
//  Copyright © 2020 liuny. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMGoodModel : NSObject

@property (nonatomic, copy) NSString *goodId;//商品id
@property (nonatomic, copy) NSString *name;//标题
@property (nonatomic, copy) NSString *coverImage;//缩略图
@property (nonatomic, copy) NSString *price;//现价
@property (nonatomic, copy) NSString *oldPrice;//原价
@property (nonatomic, copy) NSString *saleCount;//销量

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END

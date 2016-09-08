//
//  FLThirdVcRemoteModel.m
//  FLRemotePushManager
//
//  Created by 孔凡列 on 16/9/8.
//  Copyright © 2016年 clarence. All rights reserved.
//

#import "FLThirdVcRemoteModel.h"

@implementation FLThirdVcRemoteModel

+ (instancetype)fl_remotePushModel:(NSDictionary *)dict{
    FLThirdVcRemoteModel *model = [super fl_remotePushModel:dict];
    model.name = dict[@"msg"][@"name"];
    model.age = dict[@"msg"][@"age"];
    return model;
}

@end

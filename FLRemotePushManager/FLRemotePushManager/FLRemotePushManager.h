//
//  FLRemotePushManager.h
//  FLRemotePushManager
//
//  Created by clarence on 16/9/9.
//  Copyright © 2016年 clarence. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLRemotePushModel : NSObject

@property (nonatomic,copy)NSString *className;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *content;

+ (instancetype)fl_remotePushModel:(NSDictionary *)dict;

@end

@interface FLRemotePushManager : NSObject

+ (instancetype)fl_shareInstance;

- (void)fl_pushWithPushModel:(FLRemotePushModel *)remotePushModel;

@end

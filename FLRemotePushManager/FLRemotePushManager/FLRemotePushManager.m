//
//  FLRemotePushManager.m
//  FLRemotePushManager
//
//  Created by clarence on 16/9/9.
//  Copyright © 2016年 clarence. All rights reserved.
//

#import "FLRemotePushManager.h"
#import <objc/runtime.h>
@import UIKit;
@implementation FLRemotePushModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (instancetype)fl_remotePushModel:(NSDictionary *)dict{
    FLRemotePushModel *model = [[self alloc] initWithDict:dict];
    return model;
}

@end

@implementation FLRemotePushManager
+ (instancetype)fl_shareInstance{
    static FLRemotePushManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)fl_pushWithPushModel:(FLRemotePushModel *)remotePushModel{
    FLRemotePushManager *manager = [FLRemotePushManager fl_shareInstance];
    [manager push:remotePushModel];
}

/**
 *  跳转界面
 */
- (void)push:(FLRemotePushModel *)remotePushModel{
    // 类名
    NSString *class = remotePushModel.className;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass){
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    NSMutableArray *propertyArrM = [NSMutableArray array];
    for (i = 0; i < outCount; i ++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if (![propertyName isEqualToString:remotePushModel.className]) {
            [propertyArrM addObject:propertyName];
        }
    }
    
    free(properties);
    [propertyArrM enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 检测这个对象是否存在该属性
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:obj]) {
            // 利用kvc赋值
            [instance setValue:obj forKey:obj];
        }
    }];
    
    
    // 获取导航控制器
    UITabBarController *tabVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    
    // 跳转到对应的控制器
    [pushClassStance pushViewController:instance animated:YES];
}

/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

@end

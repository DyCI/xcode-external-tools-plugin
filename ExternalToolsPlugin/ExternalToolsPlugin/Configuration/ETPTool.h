//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPCommand;
@class ETPKey;


@interface ETPTool : NSObject

@property(nonatomic, strong) NSString * name;
@property(nonatomic, strong) ETPCommand * command;
@property(nonatomic, strong) ETPKey * key;

@end
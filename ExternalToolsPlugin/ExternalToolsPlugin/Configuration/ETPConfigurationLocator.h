//
// Created by Paul Taykalo on 1/19/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPConfig;


@interface ETPConfigurationLocator : NSObject

@property(nonatomic, strong) NSFileManager * fileManager;

/*
File path that is
 */
- (NSString *)fileConfigurationPath;

- (ETPConfig *)configuration;

@end
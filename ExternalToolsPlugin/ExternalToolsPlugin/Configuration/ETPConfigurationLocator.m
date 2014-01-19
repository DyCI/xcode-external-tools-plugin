//
// Created by Paul Taykalo on 1/19/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ETPConfigurationLocator.h"
#import "ETPConfig.h"


@implementation ETPConfigurationLocator
- (id)init {
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)fileConfigurationPath {
    return @"";
}

- (ETPConfig *)configuration {
    if ([self.fileManager fileExistsAtPath:@""]) {
        NSData * contents = [[self fileManager] contentsAtPath:@""];
        NSString * jsonString = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
        ETPConfig * config = [ETPConfig configWithJSONString:jsonString];
        return config;
    }
    return [ETPConfig defaultConfig];
}
@end
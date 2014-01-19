//
// Created by Paul Taykalo on 1/19/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ETPConfigurationLoader.h"
#import "ETPConfig.h"


@implementation ETPConfigurationLoader {
    enum ETPConfigurationLoadResult _loadResult;
}
- (id)init {
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (NSString *)fileConfigurationPath {
    return [@"~/.exttools.cfg" stringByExpandingTildeInPath];
}


- (ETPConfig *)loadConfiguration {
    if ([self.fileManager fileExistsAtPath:[self fileConfigurationPath]]) {
        NSData * contents = [[self fileManager] contentsAtPath:[self fileConfigurationPath]];
        NSString * jsonString = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
        if (jsonString) {
            ETPConfig * config = [ETPConfig configWithJSONString:jsonString];
            if (config) {
                _loadResult = ETPConfigurationLocatorResultSuccess;
                return config;
            }
        }
        _loadResult = ETPConfigurationLocatorResultInvalidFileFormat;

    } else {
        _loadResult = ETPConfigurationLocatorResultNoFileFound;
    }

    return [ETPConfig defaultConfig];
}


- (ETPConfigurationLoadResult)loadResult {
    return _loadResult;
}

@end
//
// Created by Paul Taykalo on 1/19/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPConfig;

typedef NS_ENUM(NSUInteger, ETPConfigurationLoadResult) {
    ETPConfigurationLocatorResultNotLoadedYet,
    ETPConfigurationLocatorResultSuccess,
    ETPConfigurationLocatorResultNoFileFound,
    ETPConfigurationLocatorResultInvalidFileFormat,
};


@interface ETPConfigurationLoader : NSObject

@property(nonatomic, strong) NSFileManager * fileManager;

/*
File path where configuration should be located
Always have default value
 */
@property(nonatomic, strong) NSString * fileConfigurationPath;

/*
Configuration that will be read at file, located at |fileConfigurationPath|
Will return default configuration if there's no file at that location, or file is invalid
 */
- (ETPConfig *)loadConfiguration;

/*
 Result of the latest configuration load process
 @see ETPConfigurationLoadResult;
 */
- (ETPConfigurationLoadResult)loadResult;

@end
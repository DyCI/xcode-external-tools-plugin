//
//  ExternalToolsPlugin.h
//  ExternalToolsPlugin
//
//  Created by Paul Taykalo on 1/17/14.
//  Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <AppKit/AppKit.h>
@class ETPConfigurationLoader;


@interface ExternalToolsPlugin : NSObject

@property(nonatomic, strong) ETPConfigurationLoader * configurationLoader;

- (id)initWithBundle:(NSBundle *)plugin;

@end
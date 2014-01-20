//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPConfig;
@class NSMenu;
@class ETPTool;


@interface ETPMenuConfigurator : NSObject

/*
Performs menu configuration, based on specified config
 */
- (BOOL)configureMenu:(NSMenu *)menu config:(ETPConfig *)config;

/*
Creates menu item for specified tool
 */
- (NSMenuItem *)menuItemForTool:(ETPTool * )tool;

@end
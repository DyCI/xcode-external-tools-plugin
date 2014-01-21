//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPConfig;
@class NSMenu;
@class ETPTool;
@class ETPToolMenuItem;

typedef void (^ETPToolSelectionBlock)(NSMenuItem * menuItem, ETPTool * tool);

@interface ETPMenuConfigurator : NSObject

/*
Performs menu configuration, based on specified config
tolSelection block - block that should be called once tool have selected
 */
- (BOOL)configureMenu:(NSMenu *)menu config:(ETPConfig *)config toolSelectionBlock:(ETPToolSelectionBlock)toolSelectionBlock;

/*
Creates menu item for specified tool
 */
- (ETPToolMenuItem *)menuItemForTool:(ETPTool * )tool;

@end
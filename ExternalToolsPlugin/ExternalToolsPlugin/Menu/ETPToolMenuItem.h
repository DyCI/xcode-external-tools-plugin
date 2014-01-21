//
// Created by Paul Taykalo on 1/21/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "ETPMenuConfigurator.h"

@interface ETPToolMenuItem : NSMenuItem

@property(nonatomic, copy) ETPToolSelectionBlock itemSelectionBlock;

@end
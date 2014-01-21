//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPCommand;
@class DSUnixTaskAbstractManager;


@interface ETPCommandRunner : NSObject

/*
Task manager that will run commands
 */
@property(nonatomic, strong) DSUnixTaskAbstractManager * taskManager;

/*
Performs command run
 */
- (void)runCommand:(ETPCommand *)command;

@end
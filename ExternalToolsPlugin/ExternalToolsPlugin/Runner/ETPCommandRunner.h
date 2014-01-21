//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ETPCommand;


@interface ETPCommandRunner : NSObject

- (void)runCommand:(ETPCommand *)command;

@end
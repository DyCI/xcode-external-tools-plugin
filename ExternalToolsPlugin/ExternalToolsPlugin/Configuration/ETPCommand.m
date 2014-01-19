//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ETPCommand.h"


@implementation ETPCommand {

}
- (instancetype)initWithCommandLine:(NSString *)commandLine inputType:(ETPInputType)inputType {
    self = [super init];
    if (self) {
        _commandLine = commandLine;
        _inputType = inputType;
    }
    return self;
}

+ (instancetype)commandWithCommandLine:(NSString *)commandLine inputType:(ETPInputType)inputType {
    return [[self alloc] initWithCommandLine:commandLine inputType:inputType];
}

@end
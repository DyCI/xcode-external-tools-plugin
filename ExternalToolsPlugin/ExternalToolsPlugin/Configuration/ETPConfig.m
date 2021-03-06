//
// Created by Paul Taykalo on 1/17/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPCommand.h"
#import "ETPKey.h"


@implementation ETPConfig {

}
+ (ETPConfig *)configWithJSONString:(NSString *)string {

    NSDictionary * jsonObject =
      [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                      options:0
                                        error:nil];
    if (jsonObject) {
        ETPConfig * config = [self configWithJSONObject:jsonObject];
        return config;
    }
    return nil;
}


+ (ETPConfig *)configWithJSONObject:(NSDictionary *)jsonObject {
    ETPConfig * config = [[[self class] alloc] init];
    config.version = jsonObject[@"version"];

    NSMutableArray * tools = [NSMutableArray array];
    config.tools = tools;

    for (NSDictionary * toolJSON in jsonObject[@"tools"]) {
        ETPTool * tool = [self toolWithJSONObject:toolJSON];
        if (tool) {
            [tools addObject:tool];
        }
    }
    return config;
}


+ (ETPTool *)toolWithJSONObject:(NSDictionary *)jsonObject {
    ETPTool * tool = [ETPTool new];
    tool.name = jsonObject[@"name"];
    tool.command = [self commandWithJSONObject:jsonObject[@"command"]];
    tool.key = [self keyWithJSONObject:jsonObject[@"key"]];
    return tool;
}


+ (ETPKey *)keyWithJSONObject:(NSDictionary * )jsonObject {
    ETPKey * key = [ETPKey new];
    key.charEquivalent = jsonObject[@"character"];

    key.modifierMask = [jsonObject[@"shift"] boolValue] ? NSShiftKeyMask : 0;
    key.modifierMask |= [jsonObject[@"control"] boolValue] ? NSControlKeyMask : 0;
    key.modifierMask |= [jsonObject[@"option"] boolValue] ? NSAlternateKeyMask : 0;
    key.modifierMask |= [jsonObject[@"command"] boolValue] ? NSCommandKeyMask : 0;

    return key;
}


+ (ETPCommand *)commandWithJSONObject:(NSDictionary *)jsonObject {
    ETPCommand * command = [ETPCommand new];
    command.commandLine = jsonObject[@"line"];

    command.inputType = ETPInputTypeNone;
    if ([jsonObject[@"input"] isCaseInsensitiveLike:@"json"]) {
        command.inputType = ETPInputTypeJson;
    }
    return command;
}


+ (ETPConfig *)defaultConfig {
    return [ETPConfig configWithJSONString:[self defaultConfigJSONString]];
}


+ (NSString *)defaultConfigJSONString {
    NSDictionary * configJSON =
    @{
      @"version" : ETP_CONFIG_VERSION,
      @"tools" : @[
      @{
        @"name" : ETP_CONFIG_DEFAULT_TOOL,
        @"key" : @{
        @"character" : @"X",
        @"command" : @YES,
        @"control" : @NO,
        @"shift" : @YES,
        @"option" : @NO
      },
        @"command" : @{
        @"line" : ETP_CONFIG_DEFAULT_TOOL_COMMAND_LINE,
        @"input" : @"none"
      }
      }
    ]
    };

    NSData * data = [NSJSONSerialization dataWithJSONObject:configJSON options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
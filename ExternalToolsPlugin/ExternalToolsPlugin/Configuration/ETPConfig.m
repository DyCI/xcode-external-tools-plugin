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
    ETPConfig * config = [self configWithJSONObject:jsonObject];
    return config;
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
    ETPConfig * config = [ETPConfig new];
    config.version = ETP_CONFIG_VERSION;

    ETPTool * tool = [ETPTool new];
    tool.name = ETP_CONFIG_DEFAULT_TOOL;

    ETPCommand * command = [ETPCommand commandWithCommandLine:ETP_CONFIG_DEFAULT_TOOL_COMMAND_LINE inputType:ETPInputTypeNone];
    tool.command = command;
    config.tools = @[tool];
    return config;
}
@end
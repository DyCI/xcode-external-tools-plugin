//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ETPMenuConfigurator.h"
#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPKey.h"


@implementation ETPMenuConfigurator {

}
- (BOOL)configureMenu:(NSMenu *)menu config:(ETPConfig *)config {
    NSMenuItem * menuItem = [menu itemWithTitle:@"File"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];

        NSMenuItem * remoteToolsItem = [[NSMenuItem alloc] initWithTitle:@"Remote tools" action:nil keyEquivalent:@"r"];
        [[menuItem submenu] addItem:remoteToolsItem];

        NSMenu * remoteToolsSubmenu = [NSMenu new];
        remoteToolsItem.submenu = remoteToolsSubmenu;

        for (ETPTool * tool in config.tools) {
            NSMenuItem * item = [self menuItemForTool:tool];
            if (item) {
                [remoteToolsSubmenu addItem:item];
            }
        }
    }

    return NO;
}

- (NSMenuItem *)menuItemForTool:(ETPTool *)tool {
    if (tool && tool.name) {
        NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:tool.name action:nil keyEquivalent:tool.key.charEquivalent ?: @"r"];
        item.keyEquivalentModifierMask = tool.key.modifierMask;
        return item;
    }
    return nil;
}

@end
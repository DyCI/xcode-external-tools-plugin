//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ETPMenuConfigurator.h"
#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPKey.h"
#import "ETPToolMenuItem.h"


@implementation ETPMenuConfigurator {

}
- (BOOL)configureMenu:(NSMenu *)menu config:(ETPConfig *)config toolSelectionBlock:(ETPToolSelectionBlock)toolSelectionBlock {
    NSMenuItem * menuItem = [menu itemWithTitle:@"File"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];

        NSMenuItem * remoteToolsItem = [[NSMenuItem alloc] initWithTitle:@"Remote tools" action:nil keyEquivalent:@"r"];
        [[menuItem submenu] addItem:remoteToolsItem];

        NSMenu * remoteToolsSubmenu = [NSMenu new];
        remoteToolsItem.submenu = remoteToolsSubmenu;

        for (ETPTool * tool in config.tools) {
            ETPToolMenuItem * item = [self menuItemForTool:tool];
            [item setItemSelectionBlock:toolSelectionBlock];
            if (item) {
                [remoteToolsSubmenu addItem:item];
            }
        }

        return YES;
    }

    return NO;
}

- (ETPToolMenuItem *)menuItemForTool:(ETPTool *)tool {
    if (tool && tool.name) {
        ETPToolMenuItem * item = [[ETPToolMenuItem alloc] initWithTitle:tool.name action:nil keyEquivalent:tool.key.charEquivalent ?: @"r"];
        item.keyEquivalentModifierMask = tool.key.modifierMask;
        item.representedObject = tool;
        item.target = self;
        item.action = @selector(handleToolMenuItemAction:);
        return item;
    }
    return nil;
}


- (void)handleToolMenuItemAction:(ETPToolMenuItem *)item {
    if (item.itemSelectionBlock) {
        item.itemSelectionBlock(item, item.representedObject);
    }
}

@end
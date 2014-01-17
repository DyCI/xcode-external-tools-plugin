//
//  ExternalToolsPlugin.m
//  ExternalToolsPlugin
//
//  Created by Paul Taykalo on 1/17/14.
//    Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ExternalToolsPlugin.h"
#import "LogClient.h"

static ExternalToolsPlugin * sharedPlugin;


@interface ExternalToolsPlugin ()

@property(nonatomic, strong) NSBundle * bundle;
@end


@implementation ExternalToolsPlugin

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString * currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}


- (id)initWithBundle:(NSBundle *)plugin {
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;

        // Create menu items, initialize UI, etc.

        // Sample Menu Item:
        NSMenuItem * menuItem = [[NSApp mainMenu] itemWithTitle:@"File"];
        if (menuItem) {
            [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
            NSMenuItem * actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action"
                                                                     action:@selector(doMenuAction)
                                                              keyEquivalent:@""];
            [actionMenuItem setTarget:self];
            [[menuItem submenu] addItem:actionMenuItem];
        }
    }
    return self;
}


// Sample Action, for menu item:
- (void)doMenuAction {
    PluginLog(@"Hi there!, I'm a plugin");
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

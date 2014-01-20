//
//  ExternalToolsPlugin.m
//  ExternalToolsPlugin
//
//  Created by Paul Taykalo on 1/17/14.
//    Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ExternalToolsPlugin.h"
#import "LogClient.h"
#import "ETPConfigurationLoader.h"
#import "ETPMenuConfigurator.h"

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
        self.configurationLoader = [ETPConfigurationLoader new];
        self.menuConfigurator = [ETPMenuConfigurator new];

        [[NSNotificationCenter defaultCenter]
          addObserverForName:NSApplicationDidFinishLaunchingNotification
                      object:nil
                       queue:nil
                  usingBlock:^(NSNotification * note) {
                      [self setupMenuItems];
                  }
        ];
        // Create menu items, initialize UI, etc.
    }
    return self;
}


- (void)setupMenuItems {

    ETPConfig * config = [self.configurationLoader loadConfiguration];
    [self.menuConfigurator configureMenu:[NSApp mainMenu] config:config];
    // Sample Menu Item:
}


// Sample Action, for menu item:
- (void)doMenuAction {
    PluginLog(@"Hi there!, I'm a plugin");
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

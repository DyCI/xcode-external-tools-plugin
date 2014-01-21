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
#import "ETPCommandRunner.h"
#import "ETPTool.h"
#import "DSUnixTaskSubProcessManager.h"

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
        self.commandRunner = [ETPCommandRunner new];
        self.commandRunner.taskManager = [NSClassFromString(@"DSUnixTaskSubProcessManager") sharedManager];

        [self onApplicationStart:^{
            [self setupMenuItems];
        }];
    }
    return self;
}


- (void)setupMenuItems {

    ETPConfig * config = [self.configurationLoader loadConfiguration];

    __weak ExternalToolsPlugin * weakSelf = self;

    [self.menuConfigurator configureMenu:[NSApp mainMenu]
                                  config:config
                      toolSelectionBlock:^(NSMenuItem * menuItem, ETPTool * tool) {
                          [weakSelf.commandRunner runCommand:tool.command];
                      }];
}


// Sample Action, for menu item:
- (void)doMenuAction {
    PluginLog(@"Hi there!, I'm a plugin");
}


#pragma mark - Helpers

- (void)onApplicationStart:(void (^)())pFunction {
    [[NSNotificationCenter defaultCenter]
      addObserverForName:NSApplicationDidFinishLaunchingNotification
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification * note) {
                  if (pFunction) {
                      pFunction();
                  }
              }
    ];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

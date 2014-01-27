//
// Created by Paul Taykalo on 1/20/14.
// Copyright (c) 2014 Stanfy. All rights reserved.
//

#import "ETPCommandRunner.h"
#import "ETPCommand.h"
#import "DSUnixTaskSubProcessManager.h"
#import "LogClient.h"
#import "DSUnixTaskAbstractManager.h"


@implementation ETPCommandRunner

- (void)runCommand:(ETPCommand *)command {
    DSUnixShellTask * task = [self.taskManager shellTask];
    [task setCommand:command.commandLine];

    //  Setting up handlers

    [task setLaunchHandler:^(DSUnixTask * taskLauncher) {
        PluginLog(@"Task started %@", command.commandLine);
    }];

    [task setFailureHandler:^(DSUnixTask * taskLauncher) {
        PluginLog(@"Task failed %@", command.commandLine);
        PluginLog(@"Task failed %i", taskLauncher.terminationStatus);
        PluginLog(@"Task failed %@", taskLauncher.standardError);
    }];

    [task setTerminationHandler:^(DSUnixTask * taskLauncher) {
        PluginLog(@"Task terminated %i", taskLauncher.terminationStatus);
    }];
    // Showing up handlers

    [task launch];
}

@end
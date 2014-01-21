#import "ExternalToolsPlugin.h"
#import "ETPConfigurationLoader.h"
#import "ETPConfig.h"
#import "ETPTool.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ExternalToolsPluginSpec)

describe(@"ExternalToolsPlugin", ^{
    __block ExternalToolsPlugin * plugin;

    beforeEach(^{
        plugin = [[ExternalToolsPlugin alloc] initWithBundle:[NSBundle mainBundle]];
    });

    context(@"By default", ^{
        it(@"should create plugin", ^{
            plugin should_not be_nil;
        });

        it(@"should have default configuration loader", ^{
            plugin.configurationLoader should_not be_nil;
        });

        it(@"should have default menu configurator", ^{
            plugin.menuConfigurator should_not be_nil;
        });
        
        it(@"should have deafult command runner", ^{
            plugin.commandRunner should_not be_nil;
        });

    });

    context(@"Once application did finish launching", ^{

        it(@"should load configuration", ^{
            spy_on(plugin.configurationLoader);
            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
            plugin.configurationLoader should have_received(@selector(loadConfiguration));
        });
        
        it(@"should configure menu, based on config", ^{
            id<CedarDouble> configurator = fake_for([ETPConfigurationLoader class]);
            plugin.configurationLoader = (id) configurator;
            ETPConfig * config = [ETPConfig new];
            [configurator add_stub:@selector(loadConfiguration)].and_return(config);

            spy_on(plugin.menuConfigurator);
            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
            plugin.menuConfigurator should have_received(@selector(configureMenu:config:toolSelectionBlock:)).with(Arguments::anything).and_with(config).and_with(Arguments::anything);
        });
        
    });
    
    context(@"Once menu did have configured", ^{

        __block NSMenu * _originalMenu;
        __block NSMenu * fileMenuSubMenu;
        beforeEach(^{
            NSMenu * mainMenu = [[NSMenu alloc] init];
            NSMenuItem * fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:@"F"];
            fileMenuSubMenu = [NSMenu new];
            [fileMenuItem setSubmenu:fileMenuSubMenu];
            [mainMenu addItem:fileMenuItem];

            _originalMenu = [NSApp mainMenu];
            [NSApp setMainMenu:mainMenu];

            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
        });

        context(@"And item selected", ^{
            __block ETPTool * tool;

            beforeEach(^{
                NSMenuItem * menuItem = [[[[fileMenuSubMenu itemArray] lastObject] submenu] itemArray][0];
                spy_on(plugin.commandRunner);

                tool = menuItem.representedObject;
                [[menuItem target] performSelector:menuItem.action withObject:menuItem];
            });

            it(@"should ask runner to run command", ^{

                plugin.commandRunner should have_received(@selector(runCommand:));

            });

            it(@"should ask runner to run command from tool, that was associated with this menuItem", ^{

                plugin.commandRunner should have_received(@selector(runCommand:)).with(tool.command);

            });

        });


        afterEach(^{
            [NSApp setMainMenu:_originalMenu];
        });
    });

});

  SPEC_END

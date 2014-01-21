#import <AppKit/AppKit.h>
#import "ETPMenuConfigurator.h"
#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPKey.h"
#import "CedarAsync.h"
#import "ETPToolMenuItem.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;
using namespace Arguments;

SPEC_BEGIN(ETPMenuConfiguratorSpec)

describe(@"ETPMenuConfigurator", ^{
    __block ETPMenuConfigurator *model;

    beforeEach(^{
        model = [ETPMenuConfigurator new];
    });

    context(@"By default", ^{
        it(@"should be able to create configurator", ^{
            model should_not be_nil;
        });
    });

    context(@"When configuring menu", ^{

        context(@"With invalid values", ^{
            it(@"should not crash", ^{
                ^{ [model configureMenu:nil config:nil toolSelectionBlock:nil];} should_not raise_exception ;
                ^{ [model configureMenu:[NSMenu new] config:nil toolSelectionBlock:nil];} should_not raise_exception ;
                ^{ [model configureMenu:nil config:[ETPConfig defaultConfig] toolSelectionBlock:nil];} should_not raise_exception ;
            });

            it(@"should return NO", ^{
                [model configureMenu:nil config:nil toolSelectionBlock:nil] should equal(NO);
                [model configureMenu:[NSMenu new] config:nil toolSelectionBlock:nil] should equal(NO);
                [model configureMenu:nil config:[ETPConfig defaultConfig] toolSelectionBlock:nil] should equal(NO);
            });

        });

        context(@"If there's Desired root menu item (File)", ^{
            __block NSMenu * menu;
            __block NSMenuItem * fileMenuItem;
            __block NSMenu * subMenu;

            beforeEach(^{
                menu = [NSMenu new];
                subMenu = [NSMenu new];
                fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:@"X"];
                [menu addItem:fileMenuItem];
                [fileMenuItem setSubmenu:subMenu];
            });

            it(@"should add separator to it's submenu", ^{
                [model configureMenu:(id) menu config:[ETPConfig defaultConfig] toolSelectionBlock:nil];
                [[[subMenu itemArray] firstObject] isSeparatorItem] should equal(YES);

            });

            it(@"should add menu items with Remote tools title and submenu", ^{
                [model configureMenu:(id) menu config:[ETPConfig defaultConfig] toolSelectionBlock:nil];

                [[[subMenu itemArray] lastObject] isSeparatorItem] should equal(NO);
                [[[subMenu itemArray] lastObject] title] should equal(@"Remote tools");
                [[[subMenu itemArray] lastObject] submenu] should_not be_nil;;
            });

            context(@"And Remote rools submenu was added", ^{
                __block NSMenu * remoteToolsSubmenu;
                __block ETPConfig * config;
                beforeEach(^{
                    config = [ETPConfig defaultConfig];
                });

                it(@"should return YES", ^{
                    [model configureMenu:(id) menu config:config toolSelectionBlock:nil] should equal(YES);
                });

                it(@"should add one item per tool", ^{
                    [model configureMenu:(id) menu config:config toolSelectionBlock:nil];
                    remoteToolsSubmenu = [[[subMenu itemArray] lastObject] submenu];
                    [[remoteToolsSubmenu itemArray] count] should equal(config.tools.count);
                });

                it(@"should have created one menu item per tool", ^{
                    spy_on(model);
                    [model configureMenu:(id) menu config:config toolSelectionBlock:nil];
                    model should have_received(@selector(menuItemForTool:)).with(config.tools.firstObject);
                });

                context(@"And user selects menuItem", ^{

                    __block NSMenuItem * toolMenuItem;
                    __block ETPTool * selectedTool;
                    __block NSMenuItem * selectedMenuItem;

                    beforeEach(^{
                        selectedMenuItem = nil;
                        selectedTool = nil;

                        [model configureMenu:(id) menu config:config toolSelectionBlock:^(NSMenuItem * menuItem, ETPTool * tool) {
                            selectedMenuItem = menuItem;
                            selectedTool = tool;
                        }];

                        remoteToolsSubmenu = [[[subMenu itemArray] lastObject] submenu];
                        toolMenuItem = [remoteToolsSubmenu itemArray][0];

                        [[toolMenuItem target] performSelector:toolMenuItem.action withObject:toolMenuItem];
                    });

                    it(@"should call toolSelectionBlock", ^{
                        in_time(selectedMenuItem) should_not be_nil;
                        in_time(selectedTool) should_not be_nil;
                    });

                    it(@"should call toolSelectionblock with item that was selected", ^{
                        in_time(selectedMenuItem) should equal(toolMenuItem);
                    });

                    it(@"should call toolSelectionblock with tool that was selected", ^{
                        in_time(selectedTool) should equal(toolMenuItem.representedObject);
                    });
                });

            });

        });

        context(@"If there's No Desired root menu item (File)", ^{
            __block id<CedarDouble> menu;
            beforeEach(^{
                menu = nice_fake_for([NSMenu class]);
                [menu add_stub:@selector(itemWithTitle:)].and_return(nil);
            });

            it(@"should return NO", ^{
                [model configureMenu:(id) menu config:[ETPConfig defaultConfig] toolSelectionBlock:nil] should equal(NO);
            });

        });

    });

    context(@"When returning menu item", ^{

        context(@"and nil tool specified", ^{
            it(@"should return nil", ^{
                [model menuItemForTool:nil] should be_nil;;
            });
        });

        context(@"and valid tool specified, retutning item", ^{
            __block ETPTool * tool;
            __block ETPKey * key;
            beforeEach(^{
                tool  = [ETPTool new];
                key = [ETPKey new];
                key.charEquivalent = @"p";
                key.modifierMask = NSControlKeyMask | NSShiftKeyMask;
            });

            it(@"should be nil if doesnt' have valid name", ^{
                [model menuItemForTool:tool] should be_nil;;
            });

            it(@"should have title from tool", ^{
                tool.name = @"123";
                [[model menuItemForTool:tool] title] should equal(tool.name);
            });

            it(@"should have key equivalent from tool key", ^{
                tool.name = @"123";
                tool.key = key;
                [[model menuItemForTool:tool] keyEquivalent] should equal(tool.key.charEquivalent);
            });

            it(@"should have modifier mask from tool key", ^{
                tool.name = @"123";
                tool.key = key;
                [[model menuItemForTool:tool] keyEquivalentModifierMask] should equal(tool.key.modifierMask);
            });

            it(@"should have represented object set to this tool", ^{
                tool.name = @"123";
                tool.key = key;
                [[model menuItemForTool:tool] representedObject] should equal(tool);
            });


        });

    });

});

SPEC_END

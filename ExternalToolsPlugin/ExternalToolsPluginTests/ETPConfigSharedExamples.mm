#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPCommand.h"
using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SHARED_EXAMPLE_GROUPS_BEGIN(ETPConfigSharedExamples)

sharedExamplesFor(@"Default config", ^(NSDictionary * sharedContext) {
    __block ETPConfig * model;
    beforeEach(^{
        model = sharedContext[@"config"];
    });


    it(@"should not be nil", ^{
        model should_not be_nil;
    });

    it(@"should have valid version", ^{
        [model version] should_not be_nil;
        [model version] should equal(ETP_CONFIG_VERSION);
    });

    it(@"should have one tool", ^{
        [model tools] should_not be_nil;
        [[model tools] count] should equal(1);
    });

    it(@"should have one tool with default name", ^{
        ETPTool * tool = [model tools][0];
        tool.name should equal(ETP_CONFIG_DEFAULT_TOOL);
    });

    it(@"should have one tool with default tool command", ^{
        ETPTool * tool = [model tools][0];
        tool.command.commandLine should equal(ETP_CONFIG_DEFAULT_TOOL_COMMAND_LINE);
    });


});

SHARED_EXAMPLE_GROUPS_END

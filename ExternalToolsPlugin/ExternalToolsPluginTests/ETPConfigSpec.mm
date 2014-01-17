#import <AppKit/AppKit.h>
#import "ETPConfig.h"
#import "ETPTool.h"
#import "ETPCommand.h"
#import "ETPKey.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ETPConfigSpec)

describe(@"ETPConfig", ^{
    __block ETPConfig *model;

    context(@"When created from json string", ^{

        beforeEach(^{
            model = [ETPConfig configWithJSONString:
              @"{\n"
                "  \"version\": \"0.1\",\n"
                "  \"tools\": [\n"
                "    {\n"
                "      \"name\": \"Echo\",\n"
                "      \"key\": {\n"
                "        \"character\": \"X\",\n"
                "        \"command\": true,\n"
                "        \"control\": false,\n"
                "        \"shift\": true,\n"
                "        \"option\": false\n"
                "      },\n"
                "      \"command\": {\n"
                "        \"line\": \"echo Hello world!\",\n"
                "        \"input\": \"none\"\n"
                "      }\n"
                "    },\n"
                "    {\n"
                "      \"name\": \"Dump Settings\",\n"
                "      \"key\": {\n"
                "        \"character\": \"Y\",\n"
                "        \"command\": true,\n"
                "        \"control\": true,\n"
                "        \"shift\": true,\n"
                "        \"option\": true\n"
                "      },\n"
                "      \"command\": {\n"
                "        \"line\": \"/bin/cat\",\n"
                "        \"input\": \"json\"\n"
                "      }\n"
                "    }\n"
                "  ]\n"
                "}"];
        });
        
        it(@"should be instantiated", ^{
            model should_not be_nil;
        });

        it(@"should correctly parse version", ^{
            [model version] should equal(@"0.1");
        });

        it(@"should correctly parse tools", ^{
            [model tools] should_not be_nil;
            [[model tools] count] should equal(2);
        });

        it(@"should correctly parse tool name", ^{
            [[model tools][0] name] should equal(@"Echo");
            [[model tools][1] name] should equal(@"Dump Settings");
        });

        it(@"should correctly parse commands", ^{
            [[model tools][0] command] should_not be_nil;
            [[model tools][1] command] should_not be_nil;
        });

        it(@"should correctly parse commands lines", ^{
            [[[model tools][0] command] commandLine] should equal(@"echo Hello world!");
            [[[model tools][1] command] commandLine] should equal(@"/bin/cat");
        });

        it(@"should correctly parse commands inputs", ^{
            [[[model tools][0] command] inputType] should equal(ETPInputTypeNone);
            [[[model tools][1] command] inputType] should equal(ETPInputTypeJson);
        });

        it(@"should correctly parse keys", ^{
            [[model tools][0] key] should_not be_nil;
            [[model tools][1] key] should_not be_nil;
        });

        it(@"should correctly parse keys char rquivalents", ^{
            ETPKey * key1 = [(ETPTool * )[model tools][0] key];
            ETPKey * key2 = [(ETPTool * )[model tools][1] key];

            [key1 charEquivalent] should equal(@"X");
            [key2 charEquivalent] should equal(@"Y");
        });

        it(@"should correctly parse keys modifiers", ^{
            ETPKey * key1 = [(ETPTool * )[model tools][0] key];
            ETPKey * key2 = [(ETPTool * )[model tools][1] key];

            [key1 modifierMask] should equal(NSCommandKeyMask | NSShiftKeyMask);
            [key2 modifierMask] should equal(NSCommandKeyMask | NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask);
        });


    });

});

SPEC_END

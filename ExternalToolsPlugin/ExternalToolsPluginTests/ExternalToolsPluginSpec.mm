#import "ExternalToolsPlugin.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ExternalToolsPluginSpec)

describe(@"ExternalToolsPlugin", ^{
    __block ExternalToolsPlugin *model;

    beforeEach(^{
        model = [[ExternalToolsPlugin alloc] initWithBundle:[NSBundle mainBundle]];
    });

    context(@"By default", ^{
        it(@"should create plugin", ^{
            model should_not be_nil;
        });

        it(@"should have default configuration loader", ^{
            model.configurationLoader should_not be_nil;
        });
    });

    context(@"Once application did finish launching", ^{

        beforeEach(^{
            spy_on(model.configurationLoader);
            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
        });

        it(@"should load configuration", ^{
            model.configurationLoader should have_received(@selector(loadConfiguration));
        });
    });

});

SPEC_END

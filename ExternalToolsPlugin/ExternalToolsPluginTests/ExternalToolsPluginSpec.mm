#import "ExternalToolsPlugin.h"
#import "ETPConfigurationLoader.h"
#import "ETPConfig.h"

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

        it(@"should have default menu configurator", ^{
            model.menuConfigurator should_not be_nil;
        });

    });

    context(@"Once application did finish launching", ^{

        it(@"should load configuration", ^{
            spy_on(model.configurationLoader);
            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
            model.configurationLoader should have_received(@selector(loadConfiguration));
        });
        
        it(@"should configure menu, based on config", ^{
            id<CedarDouble> configurator = fake_for([ETPConfigurationLoader class]);
            model.configurationLoader = (id) configurator;
            ETPConfig * config = [ETPConfig new];
            [configurator add_stub:@selector(loadConfiguration)].and_return(config);

            spy_on(model.menuConfigurator);
            [[NSNotificationCenter defaultCenter] postNotificationName:NSApplicationDidFinishLaunchingNotification object:nil];
            model.menuConfigurator should have_received(@selector(configureMenu:config:)).with(Arguments::anything).and_with(config);
        });
        
    });

});

SPEC_END

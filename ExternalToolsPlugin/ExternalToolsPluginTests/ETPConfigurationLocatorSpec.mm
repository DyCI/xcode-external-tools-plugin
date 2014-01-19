#import "ETPConfigurationLocator.h"
#import "ETPConfig.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ETPConfigurationLocatorSpec)

describe(@"ETPConfigurationLocator", ^{
    __block ETPConfigurationLocator *model;

    beforeEach(^{
        model = [ETPConfigurationLocator new];
    });

    context(@"By default", ^{
        it(@"should be able to create it", ^{
            model should_not be_nil;
        });

        it(@"should return default file coniguration location", ^{
            [model fileConfigurationPath] should_not be_nil;
        });

        it(@"should have default file manager", ^{
            [model fileManager] should_not be_nil;
        });
    });

    context(@"When configuration is asked", ^{

        context(@"By default", ^{
            it(@"should ask file manager to check if file exists", ^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                ETPConfig * config = [model configuration];
                fileManager should have_received(@selector(fileExistsAtPath:));
            });

            it(@"should ask file manager to check if file exists at fileConfiguartionPath", ^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                ETPConfig * config = [model configuration];
                fileManager should have_received(@selector(fileExistsAtPath:)).with(model.fileConfigurationPath);
            });
        });

        context(@"When there's no file at configuration path", ^{
            beforeEach(^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                [fileManager add_stub:@selector(fileExistsAtPath:)].and_return(NO);

                ETPConfig * config = [model configuration];
                [SpecHelper specHelper].sharedExampleContext[@"config"] = config;
            });

            itShouldBehaveLike(@"Default config");
        });

        context(@"When there's a file at configuration path", ^{
            __block id<CedarDouble> fileManager;
            __block NSString * configVersion;
            beforeEach(^{
                fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                [fileManager add_stub:@selector(fileExistsAtPath:)].and_return(YES);

                NSMutableDictionary * configuration = [NSMutableDictionary dictionary];
                configVersion = [NSString stringWithFormat:@"%d", arc4random_uniform(500)];
                configuration[@"version"] = configVersion;

                NSData * data = [NSJSONSerialization dataWithJSONObject:configuration options:0 error:nil];
                [fileManager add_stub:@selector(contentsAtPath:)].and_return(data);
            });

            it(@"should read file contents of that file", ^{
                ETPConfig * config = [model configuration];
                fileManager should have_received(@selector(contentsAtPath:)).with(model.fileConfigurationPath);
            });
            
            it(@"should return configuration from that file", ^{
                ETPConfig * config = [model configuration];
                [config version] should equal(configVersion);
            });
        });


    });
});

SPEC_END

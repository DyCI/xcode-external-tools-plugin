#import "ETPConfigurationLoader.h"
#import "ETPConfig.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ETPConfigurationLoaderSpec)

describe(@"ETPConfigurationLoader", ^{
    __block ETPConfigurationLoader *model;

    beforeEach(^{
        model = [ETPConfigurationLoader new];
    });

    context(@"By default", ^{
        it(@"should be able to create it", ^{
            model should_not be_nil;
        });

        it(@"should return default file coniguration location", ^{
            [model fileConfigurationPath] should_not be_nil;
        });

        it(@"should return default file coniguration location", ^{
            [model fileConfigurationPath] should_not be_empty;
        });


        it(@"should have default file manager", ^{
            [model fileManager] should_not be_nil;
        });

        it(@"should have load result as not loaded yet", ^{
            model.loadResult should equal(ETPConfigurationLocatorResultNotLoadedYet);
        });
    });

    context(@"When configuration is asked", ^{

        context(@"By default", ^{
            it(@"should ask file manager to check if file exists", ^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                ETPConfig * config = [model loadConfiguration];
                fileManager should have_received(@selector(fileExistsAtPath:));
            });

            it(@"should ask file manager to check if file exists at fileConfiguartionPath", ^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                ETPConfig * config = [model loadConfiguration];
                fileManager should have_received(@selector(fileExistsAtPath:)).with(model.fileConfigurationPath);
            });
        });

        context(@"When there's no file at configuration path", ^{
            beforeEach(^{
                id<CedarDouble> fileManager = nice_fake_for([NSFileManager class]);
                model.fileManager = (id) fileManager;
                [fileManager add_stub:@selector(fileExistsAtPath:)].and_return(NO);

                ETPConfig * config = [model loadConfiguration];
                [SpecHelper specHelper].sharedExampleContext[@"config"] = config;
            });

            it(@"should have load result as not loaded yet", ^{
                model.loadResult should equal(ETPConfigurationLocatorResultNoFileFound);
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
            });

            context(@"Then it", ^{
                it(@"should read file contents of that file", ^{
                    ETPConfig * config = [model loadConfiguration];
                    fileManager should have_received(@selector(contentsAtPath:)).with(model.fileConfigurationPath);
                });

            });

            context(@"With invalid data", ^{
                __block ETPConfig * config;
                beforeEach(^{
                    NSData * data = [@"a{}asda.." dataUsingEncoding:NSUTF8StringEncoding];
                    [fileManager add_stub:@selector(contentsAtPath:)].and_return(data);
                    config = [model loadConfiguration];
                    [SpecHelper specHelper].sharedExampleContext[@"config"] = config;
                });

                it(@"should have load result as file with invalid format", ^{
                    model.loadResult should equal(ETPConfigurationLocatorResultInvalidFileFormat);
                });

                itShouldBehaveLike(@"Default config");

            });

            context(@"With valid data", ^{
                beforeEach(^{
                    NSMutableDictionary * configuration = [NSMutableDictionary dictionary];
                    configVersion = [NSString stringWithFormat:@"%d", arc4random_uniform(500)];
                    configuration[@"version"] = configVersion;

                    NSData * data = [NSJSONSerialization dataWithJSONObject:configuration options:0 error:nil];
                    [fileManager add_stub:@selector(contentsAtPath:)].and_return(data);
                });

                it(@"should have load result as success", ^{
                    ETPConfig * config = [model loadConfiguration];
                    model.loadResult should equal(ETPConfigurationLocatorResultSuccess);
                });

                it(@"should return configuration from that file", ^{
                    ETPConfig * config = [model loadConfiguration];
                    [config version] should equal(configVersion);
                });

            });
        });


    });
});

SPEC_END

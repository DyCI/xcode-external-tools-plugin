#import "ETPConfigurationLocator.h"

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
    });
});

SPEC_END

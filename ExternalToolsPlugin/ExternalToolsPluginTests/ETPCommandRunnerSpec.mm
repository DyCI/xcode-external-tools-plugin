#import "ETPCommandRunner.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ETPCommandRunnerSpec)

describe(@"ETPCommandRunner", ^{
    __block ETPCommandRunner *model;

    beforeEach(^{
        model = [[ETPCommandRunner alloc] init];
    });

    context(@"By default", ^{
        it(@"should be able to create one", ^{
            model should_not be_nil;
        });

        it(@"should be able to run command", ^{
            [model runCommand:nil];
        });
    });
});

SPEC_END

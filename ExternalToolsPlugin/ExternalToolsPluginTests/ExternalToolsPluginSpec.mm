#import "ExternalToolsPlugin.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(ExternalToolsPluginSpec)

describe(@"ExternalToolsPlugin", ^{
    __block ExternalToolsPlugin *model;

    beforeEach(^{
        model = [[ExternalToolsPlugin alloc] init];
    });


});

SPEC_END

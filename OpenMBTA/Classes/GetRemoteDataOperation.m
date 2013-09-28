#import "GetRemoteDataOperation.h"
#import <SBJson/SBJson.h>

@implementation GetRemoteDataOperation
@synthesize urlString;

- (id)initWithURL:(NSString *)aUrlString target:(id)theTarget action:(SEL)theAction 
{
    self = [super init];
    if (self) {
        self.urlString = aUrlString;
        target = theTarget;
        action = theAction;
    }
    return self;
}


- (void)main
{
    if (self.isCancelled) return;
    if (urlString == nil) return;
    
    @autoreleasepool {
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSStringEncoding stringEncoding;
        NSError *error;
        NSString *jsonString = [NSString stringWithContentsOfURL:url usedEncoding:&stringEncoding error:&error];
        
        if (!self.isCancelled) {
            [target performSelectorOnMainThread:action withObject:jsonString waitUntilDone:NO];
        }
    
    }
}

@end

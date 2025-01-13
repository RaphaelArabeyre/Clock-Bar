#import <Cocoa/Cocoa.h>
#import "TouchButton.h"

static double LONG_PRESS_TIME = 0.5;

@interface TouchButton ()

@property double touchBeganTime;

@end


@implementation TouchButton

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)touchesBeganWithEvent:(NSEvent *)event
{

        NSSet<NSTouch *> *touches = [event touchesMatchingPhase:NSTouchPhaseBegan inView:self];

        NSTouch *touch = touches.anyObject;
        if (touch != nil)
        {
            if (touch.type == NSTouchTypeDirect)
            {
                self.touchBeganTime = [[NSDate date] timeIntervalSince1970];
            }
        }

    [super touchesBeganWithEvent:event];
}

- (void)touchesMovedWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                break;
            }
        }

    [super touchesMovedWithEvent:event];
}

- (void)touchesEndedWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseEnded inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                if(self.delegate != nil)
                {
                    double touchTime = [[NSDate date] timeIntervalSince1970] - self.touchBeganTime;
                    if(touchTime >= LONG_PRESS_TIME) {
                        [self.delegate onLongPressed: self];
                    }
                    else
                    {
                        [self.delegate onPressed: self];
                    }
                }
                break;
            }
        }

    [super touchesEndedWithEvent:event];
}

- (void)touchesCancelledWithEvent:(NSEvent *)event
{

        for (NSTouch *touch in [event touchesMatchingPhase:NSTouchPhaseMoved inView:self])
        {
            if (touch.type == NSTouchTypeDirect)
            {
                break;
            }
        }

   [super touchesCancelledWithEvent:event];
}

+ (TouchButton*)buttonWithTitle:(NSString*)title target:(id)target action:(SEL)action {
    TouchButton* button = [[TouchButton alloc] init];
    [button setTitle:title];
    [button setTarget:target];
    [button setAction:action];
    

    button.wantsLayer = YES;
    
    button.layer.cornerRadius = 0.0;
    button.layer.masksToBounds = YES;
    
    button.layer.borderWidth = 0.0;
    button.layer.shadowOpacity = 0.0;
    
    [button setBordered:NO];

    button.layer.backgroundColor = [NSColor colorWithRed:0.206 green:0.206 blue:0.206 alpha:1.0].CGColor;
    
    return button;
}

@end

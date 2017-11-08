//
//  AppDelegate.m
//  audioOSD
//
//  Created by Perceval FARAMAZ on 08/11/2017.
//  Copyright © 2017 Perceval FARAMAZ. All rights reserved.
//

#import "AppDelegate.h"

#include <dlfcn.h> //for dlopen (dylib loader)
#import "OSD.h"
#import "BezelServices.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSlider *slider;
@property (weak) IBOutlet NSButton *button;

@property float volume;
@end

static const float OSDChicletCount = 16.f; //the number of units in the OSD's level indicator

//Prototype for the function displaying the OSD on pre-Sierra systems
void *(*_BSDoGraphicWithMeterAndTimeout)(CGDirectDisplayID displayID, BSGraphic graphic, int arg3, float level, int timeout) = NULL;

// This loads macOS' BezelServices framework to display stock OSD panels (BEFORE Sierra)
bool _loadBezelServices()
{
    void *handle = dlopen("/System/Library/PrivateFrameworks/BezelServices.framework/Versions/A/BezelServices", RTLD_GLOBAL);
    
    if (!handle) {
        return NO;
    }
    else {
        _BSDoGraphicWithMeterAndTimeout = dlsym(handle, "BSDoGraphicWithMeterAndTimeout");
        return _BSDoGraphicWithMeterAndTimeout != NULL;
    }
}

// This loads macOS' OSD framework to display stock OSD panels (From macOS Sierra onwards)
bool _loadOSDFramework()
{
    return [[NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/OSD.framework"] load];
}

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // This loads the required library to display native OSDs
    
    //Loading the necessary framework to display OSD (either the 1st or the 2nd)
    if (!_loadBezelServices())
        _loadOSDFramework();
    
    _volume = _slider.floatValue;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)displayOSD:(float)level {
    if (_BSDoGraphicWithMeterAndTimeout)
        //older method (level out of 1.f)
        _BSDoGraphicWithMeterAndTimeout(CGMainDisplayID(), BSGraphicSpeakerMeter, 0x0, level/100.f, 1);
    else {
        //display using Sierra and further method
        OSDManager* sharedMgr = [NSClassFromString(@"OSDManager") sharedManager];
        [sharedMgr showImage:OSDGraphicSpeaker
                 onDisplayID:CGMainDisplayID()
                    priority:OSDPriorityDefault
               msecUntilFade:1200
              filledChiclets:level * OSDChicletCount/100
               totalChiclets:OSDChicletCount
                      locked:NO];
    }
}

-(IBAction)showAtSliderLevel:(id)sender {
    _volume = _slider.floatValue;
    
    [self displayOSD:_volume];
}

-(IBAction)stepUp:(id)sender {
    _volume = MIN(self.volume + 100.f/OSDChicletCount, 100);
    
    [self displayOSD:_volume];
}

-(IBAction)stepDown:(id)sender {
    _volume = MAX(self.volume - 100.f/OSDChicletCount, 0);
    
    [self displayOSD:_volume];
}

@end

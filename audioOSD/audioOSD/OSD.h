//
//  OSD.h
//  keytest
//
//  Created by Perceval FARAMAZ on 03/08/2017.
//  Copyright © 2017 Perceval FARAMAZ. All rights reserved.
//

#ifndef OSD_h
#define OSD_h

typedef enum {
    OSDGraphicBacklight                              = 1,//or 2,7,8,
    OSDGraphicSpeaker                                = 3,//or 5
    OSDGraphicSpeakerMuted                           = 4,//or 16
    OSDGraphicEject                                  = 6,
    OSDGraphicNoWiFi                                 = 9,//10 is crossed-out twice (wtf)
    OSDGraphicKeyboardBacklightMeter                 = 11,
    OSDGraphicKeyboardBacklightDisabledMeter = 12,
    OSDGraphicKeyboardBacklightNotConnected = 13,
    OSDGraphicMacProOpen = 15,
    //You can reverse these yourself if you need them, it's easy trial-and-error
    /*
     BSGraphicKeyboardBacklightMeter                 = //0xfffffff1,
     BSGraphicKeyboardBacklightDisabledMeter         = //0xfffffff0,
     BSGraphicKeyboardBacklightNotConnected          = //0xffffffef,
     BSGraphicKeyboardBacklightDisabledNotConnected  = //0xffffffee,
     BSGraphicMacProOpen                             = //0xffffffe9,
     BSGraphicSpeakerMuted                           = //0xffffffe8,
     BSGraphicSpeaker                                = //0xffffffe7,
     BSGraphicSpeakerDisabled                        = //0xffffffe7,
     BSGraphicRemoteBattery                          = //0xffffffe6,
     BSGraphicHotspot                                = //0xffffffe5,
     BSGraphicSleep                                  = //0xffffffe3,
     BSGraphicSpeaker                                = 3//0xffffffe2,
     BSGraphicNewRemoteBattery                       = //0xffffffcb,
     */
} OSDGraphic;

typedef enum {
    OSDPriorityDefault = 0x1f4
} OSDPriority;

@interface OSDManager : NSObject
+ (instancetype)sharedManager;

- (void)showImageAtPath:(id)arg1 onDisplayID:(unsigned int)arg2 priority:(unsigned int)arg3 msecUntilFade:(unsigned int)arg4 withText:(id)arg5;

- (void)showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout;
- (void)showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout withText:(NSString *)text;
- (void)showImage:(OSDGraphic)image onDisplayID:(CGDirectDisplayID)display priority:(OSDPriority)priority msecUntilFade:(int)timeout filledChiclets:(int)filled totalChiclets:(int)total locked:(BOOL)locked;
@end

#endif /* OSD_h */

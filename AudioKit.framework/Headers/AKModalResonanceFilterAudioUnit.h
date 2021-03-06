//
//  AKModalResonanceFilterAudioUnit.h
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

#ifndef AKModalResonanceFilterAudioUnit_h
#define AKModalResonanceFilterAudioUnit_h

#import <AudioToolbox/AudioToolbox.h>

@interface AKModalResonanceFilterAudioUnit : AUAudioUnit
@property (nonatomic) float frequency;
@property (nonatomic) float qualityFactor;

- (void)start;
- (void)stop;
- (BOOL)isPlaying;
- (void)setUpParameterRamp;
- (BOOL)isSetUp;

@property double rampTime;

@end

#endif /* AKModalResonanceFilterAudioUnit_h */

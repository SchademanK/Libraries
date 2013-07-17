//
//  NSKClmtr.m
//  NSKClmtr
//
//  Created by LUHR JENSEN on 5/14/12.
//  Copyright 2012 Klein Instruments. All rights reserved.
//

#import "NSKClmtr.h"

SubClass::SubClass(NSKClmtr* _NSK)
{
    _NSKClmtr = _NSK;
}
void SubClass::printFlicker(Flicker f)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [_NSKClmtr sendFlicker:f];
    
    [pool release];
}
void SubClass::printMeasure(Measurement m)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [_NSKClmtr sendMeasure:m];

    [pool release];

}

@implementation NSKClmtr

- (id)init
{
    self = [super init];
    if (self) {
        _kclmtr = new SubClass(self);
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(NSString*) getPort{
    return [NSString stringWithUTF8String:_kclmtr->getPort().c_str()];
}
-(void) setPort:(NSString *)PortName 
{
    _kclmtr->setPort([PortName UTF8String]);
}
-(NSString*)getSerialNumber{
    return [NSString stringWithUTF8String:_kclmtr->getSerialNumber().c_str()];
}
-(NSString*)getModel{
    return [NSString stringWithUTF8String:_kclmtr->getModel().c_str()];
}
-(bool)isPortOpen{
    return _kclmtr->isPortOpen();
}

-(void)setAimingLights:(bool) onOff{
    _kclmtr->setAimingLights(onOff);
}

//Properties - CalFiles
-(NSString*)getCalfileName{
    return [NSString stringWithUTF8String:_kclmtr->getCalFileName().c_str()];
}
-(int)getCalFileID{
    return _kclmtr->getCalFileID();
}
-(void)setCalFileID:(int)calFileID{
    _kclmtr->setCalFileID(calFileID);
}
-(matrix)getCalMatrix{
    return _kclmtr->getCalMatrix();
}
-(matrix)getRGBMatrix{
    return _kclmtr->getRGBMatrix();
}
-(WhiteSpec)getWhiteSpec{
    return _kclmtr->getWhiteSpec();
}
-(void)resetWhiteSpec{
    _kclmtr->resetWhiteSpec();
}

-(void)setWhiteSpec:(WhiteSpec)whiteSpec{
    _kclmtr->setWhiteSpec(whiteSpec);
}
-(NSArray*)getCalfileList{
    NSMutableArray *calListboo = [[NSMutableArray alloc] init];;
    const string* fileList = _kclmtr->getCalFileList();
    
    for(int i = 0; i < 97; ++i)
        [calListboo addObject:[NSString stringWithUTF8String:fileList[i].c_str()]];
    
    return calListboo;
}

-(void)setTempCalFile:(CorrectedCoefficient)matrix whitespec:(WhiteSpec)whitespec{
    _kclmtr->setTempCalFile(matrix, whitespec);
}

//Properties - FFT
-(bool)getFFT_Cosine{
    return _kclmtr->getFFT_Cosine();
}
-(void)setFFT_Cosine:(bool)value{
    _kclmtr->setFFT_Cosine(value);
}
-(bool)getFFT_Smoothing{
    return _kclmtr->getFFT_Smoothing();
}
-(void)setFFT_Smoothing:(bool)value{
    _kclmtr->setFFT_Smoothing(value);
}
-(bool)getFFT_RollOff{
    return _kclmtr->getFFT_RollOff();
}
-(void)setFFT_RollOff:(bool)value{
    _kclmtr->setFFT_RollOff(value);
}
-(int)getFFT_Samples{
    return _kclmtr->getFFT_Samples();
}
-(void)setFFT_Samples:(int)value{
    _kclmtr->setFFT_Samples(value);
}

//Measurements
-(bool)isMeasuring{
    return _kclmtr->isMeasuring();
}
-(void)startMeasuring{
    _kclmtr->startMeasuring();
}
-(void)stopMeasuring{
    _kclmtr->stopMeasuring();
}
-(AvgMeasurement)getNextMeasurment:(int)n{
    return _kclmtr->getNextMeasurement(n);
}
-(CorrectedCoefficient)getCofficintTestMatrix:(wrgb)Reference kclmtr:(wrgb)kclmtr{
    return _kclmtr->getCoefficientTestMatrix(Reference, kclmtr);
}
-(int)deleteCalFile:(int)calFileID{
    return _kclmtr->deleteCalFile(calFileID);
}
-(int)storeCalFile:(int)idNumber name:(NSString*)Name ref:(wrgb)Reference kclmtr:(wrgb)kclmtr whitespec:(WhiteSpec)whitespec{
    return _kclmtr->storeMatrices(idNumber, [Name UTF8String], Reference, kclmtr, whitespec);
}

//BlackCal - Cold
-(BlackMatrix)captureBlackLevel{
    return _kclmtr->captureBlackLevel();
}
-(BlackMatrix)getFlashMatrix{
    return _kclmtr->getFlashMatrix();
}

//BlackCal - hot
-(BlackMatrix)getRAMMatrix{
    return _kclmtr->getRAMMatrix();
}
-(BlackMatrix)getCoefficientMatrix{
    return _kclmtr->getCoefficientMatrix();
}

//FFT
-(bool)isFlickering{
    return _kclmtr->isFlickering();
}
-(int)startFlicker:(bool)grabConstantly{
    return _kclmtr->startFlicker(grabConstantly);
}
-(Flicker)getNextFlicker{
    return _kclmtr->getNextFlicker();
}
-(void)stopFlickering{
    _kclmtr->stopFlicker();
}


//Setup/closing
-(bool)connect{
    return _kclmtr->connect();
}
-(bool)connect:(NSString*)portName{
    return _kclmtr->connect([portName UTF8String]);
}
-(void)closePort{
    _kclmtr->closePort();
}

-(void)sendMeasure:(Measurement)measurement
{
    [targetMeasure performSelector:printMeasure withObject:[NSValue value:&measurement withObjCType:@encode(Measurement)]] ;
}
-(void)sendFlicker:(Flicker)flicker
{
    [targetFlicker performSelector:printFlicker withObject:[NSValue value:&flicker withObjCType:@encode(Flicker)]];
}
-(void)addTargetForMeasure:(id)target action:(SEL)action
{
    targetMeasure = target;
    printMeasure = action;
}
-(void)addTargetForFlicker:(id)target action:(SEL)action
{
    targetFlicker = target;
    printFlicker = action;
}

@end

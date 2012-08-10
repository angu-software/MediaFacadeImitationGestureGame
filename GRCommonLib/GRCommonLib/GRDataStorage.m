//
//  GRTrainigData.m
//  GestureRecognizer
//
//  Created by Andreas on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GRDataStorage.h"
#import "GRGesture.h"

@implementation GRDataStorage

@synthesize classLabels = _classLabels;
@synthesize storageData = _storageData;
@synthesize storageDataInfo = _storageDataInfo;
@synthesize isFiltered = _isFiltered;

-(id) initWithContensOfFile:(NSString*) fileName{
    if (self = [super init]) {

        [self setUpDataWithFile:fileName];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _storageData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public mehtods

-(void) filterStorrageDataWith:(id<GRFilter>) filter{
    
    for (NSString* classLabel in [_storageData allKeys]) {
        Log(@"Filtering training data for class label %@", classLabel);
        GRRecordSet *classSet = [_storageData objectForKey:classLabel];
        
        for (NSUInteger idx = 0; idx < [classSet count]; ++idx) {
            GRGesture *classRec = [classSet objectAtIndex:idx];
            GRRecord *filteredRec = [filter filterData:[GRRecord arrayWithArray:classRec.record]];
            classRec = [[GRGesture alloc] initWithRecord:filteredRec];
            [classSet replaceObjectAtIndex:idx withObject:classRec];
        }
    }
    
    self.isFiltered = YES;
}

-(void)setStorageData:(NSDictionary *)storageData{

    _storageData = [NSMutableDictionary dictionaryWithDictionary:storageData];
    if (_storageData ){
        if([[_storageData allKeys] containsObject:kGTStorageInfoIdentifier]) {
            _storageDataInfo = [_storageData objectForKey:kGTStorageInfoIdentifier];
            [(NSMutableDictionary*)_storageData removeObjectForKey:kGTStorageInfoIdentifier];
        }
        _classLabels = [_storageData allKeys];
    }
}

-(void)saveToFile:(NSString*) fileName{
    
    NSMutableDictionary* saveStorage = [[NSMutableDictionary alloc] initWithDictionary:_storageData];
    
    if (self.storageDataInfo) {
        [saveStorage setObject:self.storageDataInfo forKey:kGTStorageInfoIdentifier];
    }
    
    Log(@"Saving Storage Data%@",saveStorage);
    
    if ([NSKeyedArchiver archiveRootObject:saveStorage toFile:fileName]) {
        Log(@"Storage saved to %@", [fileName lastPathComponent]);
    }else {
        Log(@"Storage not writen to file");
    }
}

- (NSString *)description{
    return [NSString stringWithFormat:@"storage data %@ storage info: %@", self.storageData, self.storageDataInfo];
}

#pragma mark - private methods

-(void) setUpDataWithFile:(NSString*) fileName{
    NSData* loadData = [NSData dataWithContentsOfFile:fileName];
    [self setStorageData:[NSKeyedUnarchiver unarchiveObjectWithData:loadData]];

}


@end

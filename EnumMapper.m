/******************************************************************************
 *
 *       Copyright Zebra Technologies, Inc. 2014 - 2015
 *
 *       The copyright notice above does not evidence any
 *       actual or intended publication of such source code.
 *       The code contains Zebra Technologies
 *       Confidential Proprietary Information.
 *
 *
 *  Description:  AsciiProtocolHandler.m
 *
 *  Notes:
 *
 ******************************************************************************/


#import "EnumMapper.h"

@interface zt_EnumMapper()

@property (nonatomic,retain) NSMutableDictionary* currentDictionary;
@property (nonatomic, retain) NSMutableArray* currentArray;

- (NSNumber *)getKeyFromDictionary:(NSDictionary *)dictionary withValue:(NSString *)value;
- (void)printCurrentData:(NSString *)enumTitle;
@end

@implementation zt_EnumMapper

- (NSNumber *)getKeyFromDictionary:(NSDictionary *)dictionary withValue:(NSString *)value
{
    NSDictionary *dic = [dictionary copy];
    NSArray *array = [dic allKeysForObject:value];
    [dic release];
    if([array count] == 1)
    {
        return array[0];
    }
    return nil;
}

- (void)collectionsInit
{
    _currentDictionary = [[NSMutableDictionary alloc] init];
    _currentArray = [[NSMutableArray alloc] init];
}

- (id)initWithMEMORYBANKMapperForInventory
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setMEMORYBANKDictionaryAndArrayForInventory];
    }
    return self;
}

- (id)initWithMEMORYBANKMapperForPrefilters
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setMEMORYBANKDictionaryAndArrayForPrefilters];
    }
    return self;
}

- (id)initWithDIVIDERATIOMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setDIVIDERATIODictionaryAndArray];
    }
    return self;
}

- (id)initWithMODULATIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setMODULATIONDictionaryAndArray];
    }
    return self;
}

- (id)initWithFORWARDLINKMODULATIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setFORWARDLINKMODULATIONDictionaryAndArray];
    }
    return self;
}

- (id)initWithSPECTRALMASKINDICATORMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setSPECTRALMASKINDICATORDictionaryAndArray];
    }
    return self;
}

- (id)initWithSLFLAGMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setSLFLAGDictionaryAndArray];
    }
    return self;
}

- (id)initWithSESSIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setSESSIONDictionaryAndArray];
    }
    return self;
}

- (id)initWithINVENTORYSTATEMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setINVENTORYSTATEDictionaryAndArray];
    }
    return self;
}

- (id)initWithTAGPPOPULATIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setTAGPPOPULATIONDictionaryAndArray];
    }
    return self;
}

- (id)initWithTRIGGERTYPEMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setTRIGGERTYPEDictionaryAndArray];
    }
    return self;
}

- (id)initWithSELECTTARGETMapperForPrefilters
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setSELECTTARGETDictionaryAndArray];
    }
    return self;
}


- (id)initWithSELECTACTIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setSELECTACTIONDictionaryAndArray];
    }
    return self;
}

#pragma mark - Access

- (id)initWithMEMORYBANKMapperAccess
{
    self = [super init];
    if (self) {
        [self collectionsInit];
        [self setACCESSMemoryBankDictAndArray];
    }
    return self;
}
- (id)initWithMEMORYBANKMapperAccessLock
{
    self = [super init];
    if (self) {
        [self collectionsInit];
        [self setAccessLockMemoryBankDictAndArray];
    }
    return self;
}

- (id)initWithACCESSPERMISSIONMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setACCESSPERMISSIONDictionaryAndArray];
    }
    return self;
}

- (id)initWithBEEPERCONFIGMapper
{
    self = [super init];
    if(self)
    {
        [self collectionsInit];
        [self setBEEPERCONFIGDictionaryAndArray];
    }
    return self;
}

- (void)dealloc
{
    if (nil != _currentArray) {
        [_currentArray release];
    }
    if (nil != _currentDictionary)
    {
        [_currentDictionary release];
    }
    
    [super dealloc];
}

- (void)setMEMORYBANKDictionaryAndArrayForInventory
{
    [_currentDictionary setObject:@"EPC" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]];
    [_currentDictionary setObject:@"TID" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]];
    [_currentDictionary setObject:@"User" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]];
    [_currentDictionary setObject:@"Reserved" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_RESV]];
    [_currentDictionary setObject:@"None" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_NONE]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_NONE]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_RESV]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]]];
}

- (void)setMEMORYBANKDictionaryAndArrayForPrefilters
{
    [_currentDictionary setObject:@"EPC" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]];
    [_currentDictionary setObject:@"TID" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]];
    [_currentDictionary setObject:@"USER" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]];

    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]]];
}

- (void)setDIVIDERATIODictionaryAndArray
{
    [_currentDictionary setObject:@"8" forKey:[NSNumber numberWithInt:SRFID_DIVIDERATIO_DR_8]];
    [_currentDictionary setObject:@"64/3" forKey:[NSNumber numberWithInt:SRFID_DIVIDERATIO_DR_64_3]];
}

- (void)setMODULATIONDictionaryAndArray
{
    [_currentDictionary setObject:@"MV FMO" forKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_FM0]];
    [_currentDictionary setObject:@"MV 2" forKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_2]];
    [_currentDictionary setObject:@"MV 4" forKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_4]];
    [_currentDictionary setObject:@"MV 8" forKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_8]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_FM0]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_2]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_4]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MODULATION_MV_8]]];
}

- (void)setFORWARDLINKMODULATIONDictionaryAndArray
{
    [_currentDictionary setObject:@"PR ASK" forKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_PR_ASK]];
    [_currentDictionary setObject:@"SSB ASK" forKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_SSB_ASK]];
    [_currentDictionary setObject:@"DSB ASK" forKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_DSB_ASK]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_PR_ASK]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_SSB_ASK]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_FORWARDLINKMODULATION_DSB_ASK]]];
}

- (void)setSPECTRALMASKINDICATORDictionaryAndArray
{
    [_currentDictionary setObject:@"Single" forKey:[NSNumber numberWithInt:SRFID_SPECTRALMASKINDICATOR_SI]];
    [_currentDictionary setObject:@"Multi" forKey:[NSNumber numberWithInt:SRFID_SPECTRALMASKINDICATOR_MI]];
    [_currentDictionary setObject:@"Dense" forKey:[NSNumber numberWithInt:SRFID_SPECTRALMASKINDICATOR_DI]];
    
    // array is unnecessary
}

- (void)setSLFLAGDictionaryAndArray
{
    [_currentDictionary setObject:@"ASSERTED" forKey:[NSNumber numberWithInt:SRFID_SLFLAG_ASSERTED]];
    [_currentDictionary setObject:@"DEASSERTED" forKey:[NSNumber numberWithInt:SRFID_SLFLAG_DEASSERTED]];
    [_currentDictionary setObject:@"ALL" forKey:[NSNumber numberWithInt:SRFID_SLFLAG_ALL]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SLFLAG_ALL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SLFLAG_DEASSERTED]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SLFLAG_ASSERTED]]];

}

- (void)setSESSIONDictionaryAndArray
{
    [_currentDictionary setObject:@"S0" forKey:[NSNumber numberWithInt:SRFID_SESSION_S0]];
    [_currentDictionary setObject:@"S1" forKey:[NSNumber numberWithInt:SRFID_SESSION_S1]];
    [_currentDictionary setObject:@"S2" forKey:[NSNumber numberWithInt:SRFID_SESSION_S2]];
    [_currentDictionary setObject:@"S3" forKey:[NSNumber numberWithInt:SRFID_SESSION_S3]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SESSION_S0]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SESSION_S1]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SESSION_S2]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SESSION_S3]]];
}

- (void)setINVENTORYSTATEDictionaryAndArray
{
    [_currentDictionary setObject:@"STATE A" forKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_A]];
    [_currentDictionary setObject:@"STATE B" forKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_B]];
    [_currentDictionary setObject:@"AB_FLIP" forKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_AB_FLIP]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_A]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_B]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_INVENTORYSTATE_AB_FLIP]]];
}

- (void) setTAGPPOPULATIONDictionaryAndArray
{
    [_currentDictionary setObject:@"30" forKey:[NSNumber numberWithInt:30]];
    [_currentDictionary setObject:@"100" forKey:[NSNumber numberWithInt:100]];
    [_currentDictionary setObject:@"200" forKey:[NSNumber numberWithInt:200]];
    [_currentDictionary setObject:@"300" forKey:[NSNumber numberWithInt:300]];
    [_currentDictionary setObject:@"400" forKey:[NSNumber numberWithInt:400]];
    [_currentDictionary setObject:@"500" forKey:[NSNumber numberWithInt:500]];
    [_currentDictionary setObject:@"600" forKey:[NSNumber numberWithInt:600]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:30]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:100]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:200]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:300]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:400]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:500]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:600]]];
}

- (void)setTRIGGERTYPEDictionaryAndArray
{
    [_currentDictionary setObject:@"PRESS" forKey:[NSNumber numberWithInt:SRFID_TRIGGERTYPE_PRESS]];
    [_currentDictionary setObject:@"RELEASE" forKey:[NSNumber numberWithInt:SRFID_TRIGGERTYPE_RELEASE]];

    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_TRIGGERTYPE_PRESS]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_TRIGGERTYPE_RELEASE]]];

}

- (void)setSELECTTARGETDictionaryAndArray
{
    [_currentDictionary setObject:@"SESSION S0" forKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S0]];
    [_currentDictionary setObject:@"SESSION S1" forKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S1]];
    [_currentDictionary setObject:@"SESSION S2" forKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S2]];
    [_currentDictionary setObject:@"SESSION S3" forKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S3]];
    [_currentDictionary setObject:@"SL FLAG" forKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_SL]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S0]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S1]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S2]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_S3]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTTARGET_SL]]];
}

- (void)setSELECTACTIONDictionaryAndArray
{
    [_currentDictionary setObject:@"INV A NOT INV B OR ASRT SL NOT DSRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A_NOT_INV_B__OR__ASRT_SL_NOT_DSRT_SL]];
    [_currentDictionary setObject:@"INV A OR ASRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A__OR__ASRT_SL]];
    [_currentDictionary setObject:@"NOT INV B OR NOT DSRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_B__OR__NOT_DSRT_SL]];
    [_currentDictionary setObject:@"INV A2BB2A NOT INV A OR NEG SL NOT ASRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A2BB2A_NOT_INV_A__OR__NEG_SL_NOT_ASRT_SL]];
    [_currentDictionary setObject:@"INV B NOT INV A OR DSRT SL NOT ASRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_B_NOT_INV_A__OR__DSRT_SL_NOT_ASRT_SL]];
    [_currentDictionary setObject:@"INV B OR DSRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_B__OR__DSRT_SL]];
    [_currentDictionary setObject:@"NOT INV A OR NOT ASRT SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_A__OR__NOT_ASRT_SL]];
    [_currentDictionary setObject:@"NOT INV A2BB2A OR NOT NEG SL" forKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_A2BB2A__OR__NOT_NEG_SL]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A_NOT_INV_B__OR__ASRT_SL_NOT_DSRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A__OR__ASRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_B__OR__NOT_DSRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_A2BB2A_NOT_INV_A__OR__NEG_SL_NOT_ASRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_B_NOT_INV_A__OR__DSRT_SL_NOT_ASRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_INV_B__OR__DSRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_A__OR__NOT_ASRT_SL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_SELECTACTION_NOT_INV_A2BB2A__OR__NOT_NEG_SL]]];

}

#pragma mark - Access set methods
- (void)setACCESSMemoryBankDictAndArray
{
    [_currentDictionary setObject:@"EPC" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]];
    [_currentDictionary setObject:@"TID" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]];
    [_currentDictionary setObject:@"USER" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]];
    [_currentDictionary setObject:@"RESERVED" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_RESV]];
    [_currentDictionary setObject:@"ACCESS PWD" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_ACCESS]];
    [_currentDictionary setObject:@"KILL PWD" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_KILL]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_RESV]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]]];
}

- (void)setAccessLockMemoryBankDictAndArray
{
    [_currentDictionary setObject:@"EPC" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]];
    [_currentDictionary setObject:@"TID" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]];
    [_currentDictionary setObject:@"USER" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]];
    [_currentDictionary setObject:@"RESERVED" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_RESV]];
    [_currentDictionary setObject:@"ACCESS PWD" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_ACCESS]];
    [_currentDictionary setObject:@"KILL PWD" forKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_KILL]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_EPC]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_ACCESS]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_KILL]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_TID]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_MEMORYBANK_USER]]];
}
- (void)setACCESSPERMISSIONDictionaryAndArray
{
    [_currentDictionary setObject:@"Unlock" forKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE]];
    [_currentDictionary setObject:@"Permanent Unlock" forKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE_PERM]];
    [_currentDictionary setObject:@"Read And Write" forKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE_SECURED]];
    [_currentDictionary setObject:@"Permanent Lock" forKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ALWAYS_NOT_ACCESSIBLE]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE_SECURED]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ALWAYS_NOT_ACCESSIBLE]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE_PERM]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_ACCESSPERMISSION_ACCESSIBLE]]];
}

- (void)setBEEPERCONFIGDictionaryAndArray
{
    [_currentDictionary setObject:@"High" forKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_HIGH]];
    [_currentDictionary setObject:@"Medium" forKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_MEDIUM]];
    [_currentDictionary setObject:@"Low" forKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_LOW]];
    [_currentDictionary setObject:@"Quiet" forKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_QUIET]];
    
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_HIGH]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_MEDIUM]]];
    [_currentArray addObject:[_currentDictionary objectForKey:[NSNumber numberWithInt:SRFID_BEEPERCONFIG_LOW]]];
}

- (NSMutableArray *)getStringArray
{
    return _currentArray;
}
- (NSMutableDictionary *)getDictionary
{
    return _currentDictionary;
}

- (int)getIndxByEnum:(int)enumValue
{
    NSString *obj = [_currentDictionary objectForKey:[NSNumber numberWithInt:enumValue]];
    return (int)[_currentArray indexOfObject:obj];
}

- (int)getEnumByIndx:(int)indx
{
    NSString *str = [_currentArray objectAtIndex:indx];
    return [[self getKeyFromDictionary:_currentDictionary withValue:str] intValue];
}
- (NSString *)getStringByEnum:(int)enumVal
{
    return [_currentDictionary objectForKey:[NSNumber numberWithInt:enumVal]];
}
- (int)getEnumByString:(NSString *)val
{
    return [[self getKeyFromDictionary:_currentDictionary withValue:val] intValue];
}

- (void)printDebug
{
    [self clearCollections];
    [self setMEMORYBANKDictionaryAndArrayForInventory];
    [self printCurrentData:@"MEMORYBANK for inventory"];
    [self clearCollections];
    [self setMEMORYBANKDictionaryAndArrayForPrefilters];
    [self printCurrentData:@"MEMORYBANK for prefilters"];
    [self clearCollections];
    [self setDIVIDERATIODictionaryAndArray];
    [self printCurrentData:@"DIVIDERATIO"];
    [self clearCollections];
    [self setMODULATIONDictionaryAndArray];
    [self printCurrentData:@"MODULATION"];
    [self clearCollections];
    [self setFORWARDLINKMODULATIONDictionaryAndArray];
    [self printCurrentData:@"FORWARDLINKMODULATION"];
    [self clearCollections];
    [self setSPECTRALMASKINDICATORDictionaryAndArray];
    [self printCurrentData:@"SPECTRALMASKINDICATOR"];
    [self clearCollections];
    [self setSLFLAGDictionaryAndArray];
    [self printCurrentData:@"SLFLAG"];
    [self clearCollections];
    [self setSESSIONDictionaryAndArray];
    [self printCurrentData:@"SESSION"];
    [self clearCollections];
    [self setINVENTORYSTATEDictionaryAndArray];
    [self printCurrentData:@"INVENTORYSTATE"];
    [self clearCollections];
    [self setTRIGGERTYPEDictionaryAndArray];
    [self printCurrentData:@"TRIGGERTYPE"];
    [self clearCollections];
    [self setSELECTTARGETDictionaryAndArray];
    [self printCurrentData:@"SELECTTARGET"];
    [self clearCollections];
    [self setSELECTACTIONDictionaryAndArray];
    [self printCurrentData:@"SELECTACTION"];
    [self clearCollections];
    [self setACCESSPERMISSIONDictionaryAndArray];
    [self printCurrentData:@"ACCESSPERMISSION"];
    [self clearCollections];
    [self setBEEPERCONFIGDictionaryAndArray];
    [self printCurrentData:@"BEEPERCONFIG"];
    [self clearCollections];
}

- (void)printCurrentData:(NSString *)enumTitle
{
    NSLog(@"------------- %@ --------------",enumTitle);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[_currentDictionary allKeys]];
    // very simple sort
    for (int i = 0; i < [keys count]; ++i) {
        for (int j = 0; j < [keys count]; ++j) {
            if ([keys[i] intValue] < [keys[j] intValue]) {
                NSNumber *tmp = keys[i];
                keys[i] = keys[j];
                keys[j] = tmp;
            }
        }
    }
    for (NSNumber *key in keys) {
        NSString *name = [_currentDictionary objectForKey:key];
        NSString *enumValue = [NSString stringWithFormat:@"%@",key];
        NSString *idxInArray;
        if (NSNotFound == [_currentArray indexOfObject:name]) {
            idxInArray = @"not defined";
        }
        else
        {
            idxInArray = [NSString stringWithFormat:@"%lu",(unsigned long)[_currentArray indexOfObject:name]];
        }
        
        NSLog(@"enumValue=%@ Name:%@ idx=%@",enumValue,name,idxInArray);
    }
}

- (void)clearCollections
{
    [_currentArray removeAllObjects];
    [_currentDictionary removeAllObjects];
}



@end

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
 *  Description:  RfidAppEngine.h
 *
 *  Notes:
 *
 ******************************************************************************/

#import <Foundation/Foundation.h>
#import "SledConfiguration.h"
#import "AppConfiguration.h"
#import "RfidSdkApi.h"
#import "ActiveReader.h"
#import "InventoryItem.h"
#import "InventoryData.h"
#import "RegionData.h"
#import "RadioOperationEngine.h"

@protocol zt_IRfidAppEngineDevListDelegate <NSObject>
- (BOOL)deviceListHasBeenUpdated;
@end

@protocol zt_IRfidAppEngineTriggerEventDelegate <NSObject>
- (BOOL)onNewTriggerEvent:(BOOL)pressed typeRFID:(BOOL)isRFID;
@end

@protocol zt_IRfidAppEngineBatteryEventDelegate <NSObject>
- (BOOL)onNewBatteryEvent;
@end
@protocol zt_IRfidAppEngineMultiTagEventDelegate <NSObject>
- (void)onNewMultiTagEvent:(srfidTagData*)tagdata;
@end

@interface zt_RfidAppEngine : NSObject <srfidISdkApiDelegate>

+ (zt_RfidAppEngine *) sharedAppEngine;
+ (id)alloc;
+ (void)destroy;
- (id)init;
- (void)dealloc;

@property (nonatomic) BOOL isLocatingDevice;

#pragma mark - data
- (zt_ActiveReader *)activeReader;
- (zt_SledConfiguration *)sledConfiguration;
- (zt_AppConfiguration *)appConfiguration;
- (zt_SledConfiguration *)temporarySledConfigurationCopy;
- (zt_RadioOperationEngine *)operationEngine;

- (void) reconnectAfterBatchMode;
- (void) establishAsciiConnection;
- (void) postAsciiConnectionActions;

/* interface for UI */

- (NSString *)getSDKVersion;
- (srfidBatteryEvent*)getBatteryInfo;
- (NSString*)getBatteryStatusString;
- (void)resetBatteryStatusString;
- (SRFID_RESULT)fetchAllRegionData:(NSString**)statusMessage;
- (void)loadRegionsInfoIfRequired;

#pragma mark - observers management
- (void)addDeviceListDelegate:(id<zt_IRfidAppEngineDevListDelegate>)delegate;
- (void)removeDeviceListDelegate:(id<zt_IRfidAppEngineDevListDelegate>)delegate;

- (void)addTriggerEventDelegate:(id<zt_IRfidAppEngineTriggerEventDelegate>)delegate;
- (void)removeTriggerEventDelegate:(id<zt_IRfidAppEngineTriggerEventDelegate>)delegate;

- (void)addBatteryEventDelegate:(id<zt_IRfidAppEngineBatteryEventDelegate>)delegate;
- (void)removeBatteryEventDelegate:(id<zt_IRfidAppEngineBatteryEventDelegate>)delegate;

- (void)multiTagEventDelegate:(id<zt_IRfidAppEngineMultiTagEventDelegate>)delegate;

#pragma mark - device management
- (NSArray*)getActualDeviceList;
- (void)updateDeviceList;

- (void)connect:(int)reader_id;
- (void)disconnect:(int)reader_id;
- (void)sendCommand:(NSString*)cmd forReader:(int)reader_id;

- (SRFID_RESULT)locateReader:(BOOL)doEnabled message:(NSString **)statusMessage;

#pragma mark - reading command
- (SRFID_RESULT) sdkStartInventory:(int)readerID aMemoryBank:(SRFID_MEMORYBANK)memoryBankId aReportConfig:(srfidReportConfig*)reportConfig aAccessConfig:(srfidAccessConfig*)accessConfig aStatusMessage:(NSString**)statusMessage;
- (SRFID_RESULT) sdkStopInventory:(int)readerID aStatusMessage:(NSString**)statusMessage;

- (SRFID_RESULT) sdkPerformBrandCheckInventory:(int)readerID aMemoryBank:(SRFID_MEMORYBANK)memoryBankId aReportConfig:(srfidReportConfig*)reportConfig aAccessConfig:(srfidAccessConfig*)accessConfig aStatusMessage:(NSString**)statusMessage  brandId:(NSString*)brandId epcLenth:(int)epcLenth;

#pragma mark - tag locationing commands
- (SRFID_RESULT)sdkStartTagLocationing:(int)readerID aEpcId:(NSString*)tagEpcID aStatusMessage:(NSString **)statusMessage;
- (SRFID_RESULT)sdkStopTagLocationing:(int)readerID aStatusMessage:(NSString **)statusMessage;

#pragma mark - access command
- (SRFID_RESULT)readTag:(NSString*)tagID withTagData:(srfidTagData **)tagData withMemoryBankID:(SRFID_MEMORYBANK)memoryBankID withOffset:(short)offset withLength:(short)length withPassword:(long)password aStatusMessage:(NSString**)statusMessage;

- (SRFID_RESULT)writeTag:(NSString*)tagID withTagData:(srfidTagData **)tagData withMemoryBankID:(SRFID_MEMORYBANK)memoryBankID withOffset:(short)offset withData:(NSString*)data withPassword:(long)password doBlockWrite:(BOOL)blockWrite aStatusMessage:(NSString**)statusMessage;

- (SRFID_RESULT)killTag:(NSString *)tagID withTagData:(srfidTagData **)tagData withPassword:(long)password aStatusMessage:(NSString**)statusMessage;

- (SRFID_RESULT)lockTag:(NSString *)tagID withTagData:(srfidTagData **)tagData memoryBank:(SRFID_MEMORYBANK)memoryBank accessPermissions:(SRFID_ACCESSPERMISSION)accessPermissions withPassword:(long)password aStatusMessage:(NSString**)statusMessage;

#pragma mark - settings request
- (SRFID_RESULT)getSupportedLinkProfiles:(NSString **)responsMessage;
- (SRFID_RESULT)getAntennaConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)setAntennaConfigurationFromLocal:(NSString **)responsMessage;
- (SRFID_RESULT)getDpoConfiguration:(NSString **)responseMessage;
- (SRFID_RESULT)setDpoConfigurationFromLocal:(NSString **)responseMessage;
- (SRFID_RESULT)getSingulationConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)setSingulationConfigurationFromLocal:(NSString **)responsMessage;
- (SRFID_RESULT)getTagReportConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)setTagReportConfigurationFromLocal:(NSString **)responsMessage;
- (SRFID_RESULT)getStartTriggerConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)setStartTriggerConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)getStopTriggerConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)setStopTriggerConfiguration:(NSString **)responsMessage;
- (SRFID_RESULT)getSupportedRegions:(NSString **)responsMessage;
- (SRFID_RESULT)getRegionInfo:(zt_RegionData**)region_data message:(NSString **)responsMessage;
- (SRFID_RESULT)getRegulatoryConfig:(NSString **)responsMessage;
- (SRFID_RESULT)setRegulatoryConfig:(NSString **)responsMessage;
- (SRFID_RESULT)getBeeperConfig:(NSString **)responsMessage;
- (SRFID_RESULT)setBeeperConfig:(NSString **)responsMessage;
- (SRFID_RESULT)getReaderCapabilitiesInfo:(NSString **)responsMessage;
- (SRFID_RESULT)getReaderVersionInfo:(NSString **)responsMessage;
- (SRFID_RESULT)getPrefilters:(NSString **)responsMessage;
- (SRFID_RESULT)setPrefilters:(NSString **)responsMessage;
- (void)restorePrefilters;
- (SRFID_RESULT)saveReaderConfig:(NSString **)responsMessage;
- (SRFID_RESULT)requestBatteryStatus:(NSString **)responsMessage;
- (SRFID_RESULT)setBatchModeConfig:(NSString **)statusMessage;

#pragma mark - getTags in batch mode

- (SRFID_RESULT)getTags:(NSString **)statusMessage;

#pragma mark - sdk options
- (void)setAutoDetect:(BOOL)option;
- (void)setAutoReconect:(BOOL)option;

- (SRFID_RESULT)purgeTags:(NSString **)statusMessage;

#pragma  mark - UniqueTagsReport
- (SRFID_RESULT)getUniqueTagsReportConfiguration:(NSString **)responseMessage;

- (SRFID_RESULT)setUniqueTagsReportConfigurationFromLocal:(NSString **)responseMessage;

- (SRFID_RESULT)sdkStartMultiTagLocationing:(int)readerID aReportConfig:(srfidReportConfig*)reportConfig aAccessConfig:(srfidAccessConfig*)accessConfig aStatusMessage:(NSString**)statusMessage;
- (SRFID_RESULT)sdkStopMultiTagLocationing:(int)readerID aStatusMessage:(NSString **)statusMessage;

#pragma  mark - Trigger Mapping
- (SRFID_RESULT)getTriggerConfigurationUpperTrigger;
- (SRFID_RESULT)setTriggerConfigurationUpperTrigger:(SRFID_NEW_ENUM_KEYLAYOUT_TYPE)upper andLowerTrigger:(SRFID_NEW_ENUM_KEYLAYOUT_TYPE)lower;

- (SRFID_RESULT)setReaderReboot:(int)readerID status:(NSString **)statusMessage;

@end

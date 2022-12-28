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
 *  Description:  AppConfiguration.m
 *
 *  Notes:
 *
 ******************************************************************************/

#import "AppConfiguration.h"
#import "RfidAppEngine.h"
#import "ui_config.h"
#import <AudioToolbox/AudioServices.h>

#define ZT_TAGLIST_DATA_NEXTLINE_KEY_AND_ROW                     @"\r\n"

@implementation zt_AppConfiguration

- (id)init
{
    self = [super init];
    if (nil != self)
    {
        m_SearchCriteria = [[NSMutableString alloc] initWithString:@""];
        m_SelectedInventoryIdx = -1;
        m_SelectedInventoryItem = nil;
        m_SelectedInventoryMemoryBankUI = SRFID_MEMORYBANK_NONE;
        m_TagIdAccess = [[NSMutableString alloc] initWithString:@""];
        m_TagIdLocationing = [[NSMutableString alloc] initWithString:@""];
        currentlySelectedTagIdArray = [[NSMutableArray alloc] init];
        currentlySelectedTagIdObjectArray = [[NSMutableArray alloc] init];
        isMultitagLocated = NO;
        tagListPredicateArray = [[NSMutableArray alloc] init];
        tagListArray = [[NSArray alloc] init];
        multiTagPredicateArray = [[NSMutableArray alloc] init];
     
    }
    return self;
}

- (void)dealloc
{
    if (nil != m_SearchCriteria)
    {
        [m_SearchCriteria release];
    }
    
    if (nil != m_SelectedInventoryItem)
    {
        [m_SelectedInventoryItem release];
    }
    
    if (nil != m_TagIdLocationing)
    {
        [m_TagIdLocationing release];
    }
    
    if (nil != m_TagIdAccess)
    {
        [m_TagIdAccess release];
    }
    if (nil != tagListPredicateArray)
    {
        [tagListPredicateArray release];
    }
    
    if (nil != multiTagPredicateArray)
    {
        [multiTagPredicateArray release];
    }
    
    if (nil != tagListArray)
    {
        [tagListArray release];
    }
    
    if (nil != currentlySelectedTagIdArray)
    {
        [currentlySelectedTagIdArray release];
    }
    
    if (nil != currentlySelectedTagIdObjectArray)
    {
        [currentlySelectedTagIdObjectArray release];
    }
    
    [super dealloc];
}


- (void)loadAppConfiguration
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    
    /*
     NSUserDefaults returns 0 for number if the key doesn't exist
     Check that 0 is not a valid value for the parameter
     
     */
    
    int _app_exists = (int)[settings integerForKey:ZT_APP_CFG_APP_INSTALLED];
    
    if (_app_exists == 0)
    {
        /* no value => setup default values */
        [settings setInteger:1 forKey:ZT_APP_CFG_APP_INSTALLED];
        [settings setBool:YES forKey:ZT_APP_CFG_CONNECTION_AUTO_DETECTION];
        [settings setBool:NO forKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
        [settings setBool:NO forKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
        [settings setBool:NO forKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
        [settings setBool:YES forKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
        [settings setBool:NO forKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
        [settings setBool:NO forKey:ZT_APP_CFG_APP_DATA_EXPORT];
        [settings setBool:NO forKey:ZT_APP_CFG_APP_MATCH_MODE];
        [settings setBool:NO forKey:ZT_APP_CFG_APP_FRIENDLY_NAMES];
        [settings setBool:NO forKey:ZT_APP_CFG_APP_ASCII_MODE];
    }
    
    m_ConfigConnectionAutoDetection = [settings boolForKey:ZT_APP_CFG_CONNECTION_AUTO_DETECTION];
    m_ConfigConnectionAutoReconnection = [settings boolForKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
    m_ConfigHostBeeperEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
    m_ConfigNotificationAvailable = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
    m_ConfigNotificationBattery = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
    m_ConfigNotificationConnection = [settings boolForKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
    m_ConfigDataExport = [settings boolForKey:ZT_APP_CFG_APP_DATA_EXPORT];
    m_ConfigMatchMode = [settings boolForKey:ZT_APP_CFG_APP_MATCH_MODE];
    m_ConfigFriendlyNames = [settings boolForKey:ZT_APP_CFG_APP_FRIENDLY_NAMES];
    m_ConfigASCIIMode = [settings boolForKey:ZT_APP_CFG_APP_ASCII_MODE];
}

- (BOOL)getConfigConnectionAutoDetection
{
    return YES;
}

- (BOOL)getConfigConnectionAutoReconnection
{
    return m_ConfigConnectionAutoReconnection;
}

- (void)setConfigConnectionAutoReconnection:(BOOL)option
{
    if (option != m_ConfigConnectionAutoReconnection)
    {
        m_ConfigConnectionAutoReconnection = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigConnectionAutoReconnection forKey:ZT_APP_CFG_CONNECTION_AUTO_RECONNECTION];
    }
}

- (BOOL)getConfigNotificationAvailable
{
    return m_ConfigNotificationAvailable;
}

- (void)setConfigNotificationAvailable:(BOOL)option
{
    if (option != m_ConfigNotificationAvailable)
    {
        m_ConfigNotificationAvailable = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationAvailable forKey:ZT_APP_CFG_NOTIFICATION_AVAILABLE];
    }
}

- (BOOL)getConfigNotificationConnection
{
    return m_ConfigNotificationConnection;
}

- (void)setConfigNotificationConnection:(BOOL)option
{
    if (option != m_ConfigNotificationConnection)
    {
        m_ConfigNotificationConnection = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationConnection forKey:ZT_APP_CFG_NOTIFICATION_CONNECTION];
    }
}

- (BOOL)getConfigNotificationBattery
{
    return m_ConfigNotificationBattery;
}

- (void)setConfigNotificationBattery:(BOOL)option
{
    if (option != m_ConfigNotificationBattery)
    {
        m_ConfigNotificationBattery = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigNotificationBattery forKey:ZT_APP_CFG_NOTIFICATION_BATTERY];
        if (NO == option)
        {
            /* nrv364: reset stored critical/low battery status when notifications are disabled */
            [[zt_RfidAppEngine sharedAppEngine] resetBatteryStatusString];
        }
    }
}

- (BOOL)getConfigHostBeeperEnabled
{
    return m_ConfigHostBeeperEnabled;
}

- (void)setConfigHostBeeperEnabled:(BOOL)option
{
    if (option != m_ConfigHostBeeperEnabled)
    {
        m_ConfigHostBeeperEnabled = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigHostBeeperEnabled forKey:ZT_APP_CFG_HOST_BEEPER_ENABLED];
    }
}

- (BOOL)getConfigDataExport
{
    return m_ConfigDataExport;
}

- (void)setConfigDataExport:(BOOL)option
{
    if (option != m_ConfigDataExport) {
        m_ConfigDataExport = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigDataExport forKey:ZT_APP_CFG_APP_DATA_EXPORT];
    }
}

/// Getting the matchmode configuration from local config.
///@return The selected matchmode bool value from local config.
- (BOOL)getConfigMatchMode
{
    return m_ConfigMatchMode;
}

/// Setting up the matchmode configuration to get the application status.
/// @param option If user set option for true will give the matched tags from the tags list  else nothing.
- (void)setConfigMatchMode:(BOOL)option
{
    if (option != m_ConfigMatchMode) {
        m_ConfigMatchMode = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigMatchMode forKey:ZT_APP_CFG_APP_MATCH_MODE];
    }
}

/// Getting the friendly names configuration from local config.
///@return The selected friendly names bool value from local config.
- (BOOL)getConfigFriendlyNames
{
    return m_ConfigFriendlyNames;
}

/// Setting up the friendly names configuration to get the names of sleds.
/// @param option If user set option for true will give the frindly named readers in the readers list  else nothing.
- (void)setConfigFriendlyNames:(BOOL)option
{
    if (option != m_ConfigFriendlyNames) {
        m_ConfigFriendlyNames = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigFriendlyNames forKey:ZT_APP_CFG_APP_FRIENDLY_NAMES];
    }
}

/// Getting the ascii mode configuration from local config.
///@return The selected ascii mode bool value from local config.
- (BOOL)getConfigASCIIMode
{
    return m_ConfigASCIIMode;
}

/// Setting up the ascii mode configuration to update the ascii encription.
/// @param option If user set option for true will readers will start reading tags with ascii encription else nothing.
- (void)setConfigASCIIMode:(BOOL)option
{
    if (option != m_ConfigASCIIMode) {
        m_ConfigASCIIMode = option;
        [[NSUserDefaults standardUserDefaults] setBool:m_ConfigASCIIMode forKey:ZT_APP_CFG_APP_ASCII_MODE];
    }
}

- (NSString*)getConfigAsciiPassword:(int)reader_id
{
    NSString *key = [NSString stringWithFormat:@"%@_readerid_%d_", ZT_APP_CFG_READER_ASCII_PASSWORD, reader_id];
    NSString *pwd = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return pwd;
}

- (void)setConfigAsciiPassword:(NSString*)password forReader:(int)reader_id
{
    NSString *key = [NSString stringWithFormat:@"%@_readerid_%d_", ZT_APP_CFG_READER_ASCII_PASSWORD, reader_id];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:key];
}


- (void)setTagSearchCriteria:(NSString*)criteria
{
    [m_SearchCriteria setString:criteria];
}

- (NSString*)getTagSearchCriteria
{
    return [NSString stringWithString:m_SearchCriteria];
}

- (zt_InventoryItem *)getSelectedInventoryItem
{
    return m_SelectedInventoryItem;
}

- (int)getSelectedInventoryItemIndex
{
    return m_SelectedInventoryIdx;
}

- (void)setSelectedInventoryItem:(zt_InventoryItem *)item withIdx:(int)index
{
    m_SelectedInventoryItem = [item retain];
    m_SelectedInventoryIdx = index;
}

- (void)clearSelectedItem
{
    if (nil != m_SelectedInventoryItem) {
        [m_SelectedInventoryItem release];
        m_SelectedInventoryItem = nil;
    }
    
    m_SelectedInventoryIdx = -1;
}

- (SRFID_MEMORYBANK)getSelectedInventoryMemoryBankUI
{
    return m_SelectedInventoryMemoryBankUI;
}

- (void)setSelectedInventoryMemoryBankUI:(SRFID_MEMORYBANK)val
{
    m_SelectedInventoryMemoryBankUI = val;
}

- (NSString*)getTagIdLocationing
{
    return [NSString stringWithString:m_TagIdLocationing];
}

- (void)setTagIdLocationing:(NSString*)val
{
    [m_TagIdLocationing setString:val];
}

- (void)clearTagIdLocationingGracefully
{
    NSString *selected_tag_id = [m_SelectedInventoryItem getTagId];
    if (NSOrderedSame == [m_TagIdLocationing caseInsensitiveCompare:selected_tag_id])
    {
        [m_TagIdLocationing setString:@""];
    }
}

- (NSString*)getTagIdAccess
{
    return [NSString stringWithString:m_TagIdAccess];
}

- (void)setTagIdAccess:(NSString*)val
{
    [m_TagIdAccess setString:val];
}
- (void)clearTagIdAccessGracefully
{
    NSString *selected_tag_id = [m_SelectedInventoryItem getTagId];
    if (NSOrderedSame == [m_TagIdAccess caseInsensitiveCompare:selected_tag_id])
    {
        [m_TagIdAccess setString:@""];
    }
}


/// Remove all multi tag id
- (void)removeAllMultiTagIds
{
    if(currentlySelectedTagIdArray.count > 0)
    {
        [currentlySelectedTagIdArray removeAllObjects];
    }
}


/// Add tag id into multi tag array
/// @param tagId The tag id
-(void)addTagIdIntoMultiTagArray:(NSString*)tagId
{
    if (![currentlySelectedTagIdArray containsObject:tagId])
    {
        [currentlySelectedTagIdArray addObject:tagId];
    }
}


/// Addd invetory tag object into multi tag array
/// @param tagItemObject The tag id object
-(void)addInvetoryTagObjectIntoMultiTagArray:(zt_InventoryItem*)tagItemObject
{
    if (![currentlySelectedTagIdObjectArray containsObject:tagItemObject])
    {
        [currentlySelectedTagIdObjectArray addObject:tagItemObject];
    }
}

/// Get invetory tag object by tag id
/// @param tagId The tag object
-(zt_InventoryItem*)getInvetoryTagObjectByTagId:(NSString*)tagId
{
    for(zt_InventoryItem *tagItemObject in currentlySelectedTagIdObjectArray){
        
        if([tagItemObject getTagId] == tagId){
            return tagItemObject;
        }
    }
    return nil;
}

/// Get multi tag id array
- (NSMutableArray*)getMultiTagIdArray
{
    return currentlySelectedTagIdArray;
}


/// Set currently selected tag id array
/// @param array The array
-(void)setCurrentlySelectedTagIdArray:(NSMutableArray*)array
{
    [currentlySelectedTagIdArray removeAllObjects];
    currentlySelectedTagIdArray = [array mutableCopy];
}


/// Remove item in multi tag id locationing array
/// @param tagId The tag id
- (void)removeItemInMultiTagIdLocationingArray:(NSString*)tagId
{
    if (currentlySelectedTagIdArray.count > 0)
    {
        if ([currentlySelectedTagIdArray containsObject:tagId])
        {
            [currentlySelectedTagIdArray removeObject:tagId];
        }
    }
}

/// Create the taglist array using imported .csv file.
/// @param tagList The string with multiple tagid.
- (void)createTagListArrayFromCsvFile:(NSString*)tagList
{
    
    NSArray * tagListArrayValue = [[NSArray alloc] init];

    if ([tagList containsString:ZT_TAGLIST_DATA_NEXTLINE_KEY_AND_ROW]){
        tagListArrayValue = [tagList componentsSeparatedByString:ZT_TAGLIST_DATA_NEXTLINE_KEY_AND_ROW];
    }else{
        tagListArrayValue = [tagList componentsSeparatedByString:ZT_TAGLIST_DATA_NEXTLINE_KEY];
    }
    
    tagListPredicateArray = [tagListArrayValue mutableCopy];
        
    if ([[tagListPredicateArray objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] containsString:ZT_FRIENDLYNAME_TAG_IDS] || [[tagListPredicateArray objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] containsString:ZT_FRIENDLYNAME_ITEM_NAME]) {
        [tagListPredicateArray removeObjectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0];
    }
        NSMutableArray * temporaryTagListArray = [[NSMutableArray alloc] init];
        for (NSString *predicateString in tagListPredicateArray)
        {
            NSArray *items = [predicateString componentsSeparatedByString:ZT_FRIENDLYNAME_COMMA];
            TaglistDataObject *tagListDataModel = [[TaglistDataObject alloc] init];
            
            if ([items count] > 0) {
                if ([[items objectAtIndex:0] isEqualToString:ZT_FRIENDLYNAME_EMPTY_STRING]) {
                    continue;
                }
            }
            
            if ([items count] > ZT_FRIENDLYNAME_ARRAY_COUNT) {
                [tagListDataModel initWithTagIDFromCSVFile:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] itemName:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_1]];
            }else
            {
                [tagListDataModel initWithTagIDFromCSVFile:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] itemName:ZT_FRIENDLYNAME_EMPTY_STRING];
            }
            [temporaryTagListArray addObject:tagListDataModel];
        }
        tagListArray = [temporaryTagListArray mutableCopy];
        
        
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tagListArray];
        [currentDefaults setObject:data forKey:ZT_TAGLIST_ARRAY_DEFAULTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
}

/// To get the new taglist array created from the string.
- (NSArray*)getCsvTagListArray
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:ZT_TAGLIST_ARRAY_DEFAULTS_KEY];
    tagListArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return tagListArray;
}

/// Create the multitag array using imported .csv file.
/// @param multiTag The string with multiple tagid.
- (void)createMultiTagArrayFromCsvFile:(NSString*)multiTag
{
    NSArray * tagListArrayValue = [[NSArray alloc] init];
    
    if ([multiTag containsString:ZT_TAGLIST_DATA_NEXTLINE_KEY_AND_ROW]){
        tagListArrayValue = [multiTag componentsSeparatedByString:ZT_TAGLIST_DATA_NEXTLINE_KEY_AND_ROW];
    }else{
        tagListArrayValue = [multiTag componentsSeparatedByString:ZT_TAGLIST_DATA_NEXTLINE_KEY];
    }
    
    multiTagPredicateArray = [tagListArrayValue mutableCopy];
        
    if ([[multiTagPredicateArray objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] containsString:ZT_FRIENDLYNAME_TAG_IDS] || [[multiTagPredicateArray objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] containsString:ZT_FRIENDLYNAME_ITEM_NAME]) {
        [multiTagPredicateArray removeObjectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0];
    }
    
        NSMutableArray * temporaryMultiTagArray = [[NSMutableArray alloc] init];
        for (NSString *predicateString in multiTagPredicateArray)
        {
            NSArray *items = [predicateString componentsSeparatedByString:ZT_FRIENDLYNAME_COMMA];
            TaglistDataObject *tagListDataModel = [[TaglistDataObject alloc] init];
            if ([items count] > ZT_FRIENDLYNAME_ARRAY_COUNT) {
                [tagListDataModel initWithTagIDFromCSVFile:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] itemName:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_1]];
            }else
            {
                [tagListDataModel initWithTagIDFromCSVFile:[items objectAtIndex:ZT_FRIENDLYNAME_ARRAY_OBJECT_0] itemName:ZT_FRIENDLYNAME_EMPTY_STRING];
            }
            [temporaryMultiTagArray addObject:tagListDataModel];
        }
        multiTagArray = [temporaryMultiTagArray mutableCopy];
}

/// To get the new multitag array created from the string.
- (NSArray*)getCsvMultiTagArray
{
    return multiTagArray;
}


/// To play host beeper
- (void)playHostBeeper
{
    BOOL inventoryRequested = [[[zt_RfidAppEngine sharedAppEngine] operationEngine] getStateInventoryRequested];
    zt_SledConfiguration * sledConfiguraion = [[zt_RfidAppEngine sharedAppEngine] temporarySledConfigurationCopy];
    if (inventoryRequested) {
        if (sledConfiguraion.hostBeeperEnable)
        {
            AudioServicesPlaySystemSound(ZT_HOST_BEEPER_SYSTEM_SOUND_ID);
        }
    }
}

// Taglist Filter

/// Set the taglist filter option.
/// @param filter The filter value from the core class.
- (void)setTagListFilter:(int)filter
{
    selectedTagListFilter = filter;
}

/// Get the taglist filter.
- (int)getTagListFilter
{
    return selectedTagListFilter;
}

// Multitag Locate
- (void)saveIsMultitagLocated:(BOOL)locate
{
    isMultitagLocated = locate;
}
- (BOOL)isMultiTagLocated
{
    return isMultitagLocated;
}


/// To set the multitag locating status.
/// @param locationing Status of locating.
- (void)setIsMultitagLocationing:(BOOL)locationing
{
    isMultitagLocationing = locationing;
}

/// To get the multitag locating status.
- (BOOL)getIsMultiTagLocationing
{
    return isMultitagLocationing;
}

@end

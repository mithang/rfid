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
 *  Description:  RegulatorySettingsVC.h
 *
 *  Notes:
 *
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "SwitchCellView.h"
#import "InfoCellView.h"
#import "SelectionTableVC.h"

@interface zt_RegulatorySettingsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, zt_IOptionCellDelegate, zt_ISelectionTableVCDelegate>
{
    IBOutlet UITableView *m_tblRegulatoryOptions;
    /* cells */
    zt_InfoCellView *m_cellRegion;
    zt_SwitchCellView *m_OffscreenSwitchCell;
    
    UIBarButtonItem *m_btnSave;
    BOOL m_ModalMode;
    BOOL m_HasAppeared;
    BOOL inventoryRequested;
}

- (void)setModalMode:(BOOL)enabled;
- (void)btnSavePressed;
- (void)createPreconfiguredOptionCells;
- (void)configureSwitchCell:(zt_SwitchCellView*)cell forRow:(int)row;
- (void)setupConfigurationInitial;

@end

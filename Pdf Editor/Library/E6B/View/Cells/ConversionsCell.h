//
//  CalculationsCell.h
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface ConversionsCell : UITableViewCell <UIPopoverControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
NSDictionary * dictTimeZone;
}
@property (nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;
@property(nonatomic)NSInteger lastTextFieldTag;
@end

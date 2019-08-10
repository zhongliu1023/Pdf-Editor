//
//  PerformanceCell.h
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface PerformanceCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;
@property (strong, nonatomic) IBOutlet UIButton *btnClearAll;
@property(nonatomic)NSInteger lastTextFieldTag;
@end

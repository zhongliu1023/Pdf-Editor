//
//  ConversionsCell.h
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface CalculationsCell : UITableViewCell
{
    BOOL checkTime;
}
@property(nonatomic) NSInteger previousTextFieldTag;
@property (nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;
@property(nonatomic)NSInteger lastTextFieldTag;
@end

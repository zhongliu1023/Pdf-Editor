//
//  SectionHeaderView.h
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;

@property (nonatomic, assign) NSInteger sectionIndex;
- (IBAction)actionClearAll:(id)sender;
- (IBAction)backAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *wtClearAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *wtBackBtn;
+ (instancetype)sectionHeaderView;
@end

//
//  WeightAndBalanceCell.h
//  FliteCalculators
//
//  Created by inextsol on 11/3/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "WeightBalance.h"
#import "TMLineGraph.h"

@interface WeightAndBalanceCell : UITableViewCell<UITextFieldDelegate, UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property CAShapeLayer *shapeLayerGraph,*shapeLayerGraphLine,*shapeLayerRedLine,*shapeLayerGraphUtility;
@property (strong,nonatomic)IBOutlet UIButton *wtClearBackBtn;
@property (strong, nonatomic)TMLineGraph *momentGraph;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;
@property(nonatomic)NSInteger lastTextFieldTag;

@property(strong,nonatomic)IBOutlet UITableView *saveTableView;
@property (weak,nonatomic)IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldName;
- (IBAction)actionSave:(id)sender;
@property(nonatomic,strong)NSMutableArray *arrayFiles;

- (IBAction)actionClearAll:(id)sender;

- (IBAction)backSaveAll:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnClearAll;
@property (strong,nonatomic)WeightBalance * wtTextValue;
@property (assign,nonatomic)BOOL isSaveFileSelected;
@end

//
//  WeightAndBalanceCell.m
//  FliteCalculators
//
//  Created by inextsol on 11/3/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//

#import "WeightAndBalanceCell.h"
#import "WeightBalance.h"
#import "CSIP-Swift.h"
#define ENTITY_WEIGHTBALANCE @"WeightBalance"
typedef enum : NSUInteger {
    
    BASICEMPTYWEIGHT=10,
    FRONTPAX1,
    FROTPAX2,
    BACKPAX1,
    BACKPAX2,
    CARGO1,
    CARGO2,
    EMPTYFUEL,
    MAINTHANKS,
    FUELAUXTANKS,
    TOTAL,
    MAXRAMPWEIGHT,
    MAXTAKOFWEIGHT,
    MAXLANDINGWEIGHT,
    MAXEMPTYFUELWEIGHT,
    MAXCARGO1WEIGHT,
    MAXCARGO2WEIGHT,
    RANGEATMAXGROSSWEIGHT,
    RANGEATMAXTAKEOFWEIGHT,
    RANGEATEMPTYFUELWEIGHT,
    RANGEATBASICEMTYWEIGHT,
    RANGEATMAXGROSSWEIGHT2,
    RANGEATMAXTAKEOFFWEIGHT2,
    RANGEATEMPTYFUELWEIGHT2,
    RANGEATBASICEMPTYWEIGHT2
    
} WeightAndBalance;

@implementation WeightAndBalanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isSaveFileSelected = NO;
//    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.containerView.layer.borderWidth = 1.0;
    self.arrayFiles=[[NSMutableArray alloc] init];
    self.saveBtn.layer.cornerRadius = 5.0;
    self.saveBtn.layer.borderWidth = 1.0;
    self.saveBtn.layer.borderColor = self.saveBtn.titleLabel.textColor.CGColor;
    
    for (UIView *subView in self.containerView.subviews) {
        //        if (subView.subviews.count == 0){
        //            continue;
        //        }
        //        for (UIView *aView in subView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
            textField.layer.cornerRadius=5.0;
            textField.layer.borderWidth=1.0;
            textField.borderStyle=UITextBorderStyleNone;

            if (textField.tag==171 || textField.tag==172 || textField.tag==173 || textField.tag==201 || textField.tag==202 || textField.tag==203) {
                textField.textColor=[UIColor blackColor];
            }else {
                textField.textColor=[UIColor blueColor];
                [textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
            }
            //                UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
            //                numberToolbar.barStyle = UIBarStyleBlackTranslucent;
            //                numberToolbar.items = [NSArray arrayWithObjects:
            //                                       [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)], nil];
            //                [numberToolbar sizeToFit];
            //                textField.inputAccessoryView = numberToolbar;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.delegate = self;
            //                 textField.placeholder = @"0.00";
        }
        else if ([subView isKindOfClass:[UIButton class]]) {
            //                 Adding rounded corner to button
            UIButton *button = (UIButton *)subView;
            if ([[button currentTitle] isEqualToString:@"CLEAR"]) {
                button.layer.cornerRadius = 10;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor blueColor].CGColor;
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
            
            
            //                button.layer.borderColor = [UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0].CGColor;
            //                [button setTitleColor:[UIColor colorWithRed:173/255.0 green:216/255.0 blue:230/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else if ([subView isKindOfClass:[UILabel class]] ) {
            UILabel *label=(UILabel*)subView;
            if (label.tag==5 || label.tag==6) {
                label.transform=CGAffineTransformMakeRotation(-90*M_PI/180);
                CGRect frame=label.frame;
                if (label.tag==5) {
                    frame.origin.y=1256;
                }else
                    frame.origin.y=1535;
                frame.origin.x=10;
                label.frame=frame;
            }
        }
        // }
    }
    [self getSavedFiles];
    self.btnClearAll.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.btnClearAll.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    [self.btnClearAll setTitle: @"CLEAR\nALL" forState: UIControlStateNormal];
    self.btnClearAll.layer.cornerRadius = 10;
    self.btnClearAll.layer.borderWidth = 1;
    self.btnClearAll.layer.borderColor = [UIColor blueColor].CGColor;
    [self.btnClearAll setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearText:) name:@"ClearWeightText" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadbackText:) name:@"BackWeightText" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearText:) name: @"ClearText" object:nil];

    self.saveTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (IBAction)backSaveAll:(UIButton *)sender
{
    sender.hidden = YES;
    self.isSaveFileSelected = NO;
    [self displayDetails:self.wtTextValue];
}
-(void)reloadbackText:(NSNotification *) notification {
    self.isSaveFileSelected = NO;
    [self displayDetails:self.wtTextValue];
}
-(void)clearText:(NSNotification *) notification {
    if (self.isSaveFileSelected == NO) {
        for (UITextField *subView in self.containerView.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subView;
                textField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
                   
                textField.text=@"";
            }
        }
    }else
    {
        
    }
    
}
///-------------------------------------------------
#pragma mark - KeyBoard Done Handler
///-------------------------------------------------
- (void)doneWithNumberPad{
    [self endEditing:YES];
}

///-------------------------------------------------
#pragma mark - UITextFieldDelegate Methods
///-------------------------------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if ([self.keyboardDelegate respondsToSelector:@selector(keyboardWillPresentForTextField:)]) {
        [self.keyboardDelegate keyboardWillPresentForTextField:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.lastTextFieldTag=textField.tag;
    [self drawGraphValue:0 newValue:@"0"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag!=1020) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:filtered];
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."] && range.length<1) {
            finalString=[finalString substringToIndex:[finalString length] - 1];
        }
        double newValue=[finalString doubleValue];
        //    if (textField.tag==161 || textField.tag==162 ||textField.tag==163 || textField.tag==171 || textField.tag==172 || textField.tag==173) {
        //        newValue=[self getdecimalTimeFromString:finalString];
        //    }
        [self valueChangedInConversionTableForMeasurement:(textField.tag/10) forUnit:(textField.tag % 10) withNewValue:newValue];
        textField.text = finalString;
        return NO;
    }return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)valueChangedInConversionTableForMeasurement:(WeightAndBalance)measurement forUnit:(NSInteger)unitId withNewValue:(double)newValue{
    
    switch (measurement) {
        case BASICEMPTYWEIGHT:
            [self calculateBasicEmptyWeightInUnit:unitId toNewValue:newValue];
            break;
            
        case FRONTPAX1:
            [self calculateFrontPax1InUnit:unitId toNewValue:newValue];
            break;
            
        case FROTPAX2:
            [self calculateFrontPax2InUnit:unitId toNewValue:newValue];
            break;
            
        case BACKPAX1:
            [self calculateBackPax1InUnit:unitId toNewValue:newValue];
            break;
            
        case BACKPAX2:
            [self calculateBackPax2InUnit:unitId toNewValue:newValue];
            break;
            
        case CARGO1:
            [self calculateCargo1InUnit:unitId toNewValue:newValue];
            break;
            
        case CARGO2:
            [self calculateCargo2InUnit:unitId toNewValue:newValue];
            
            break;
            
        case EMPTYFUEL:
            break;
        case MAINTHANKS:
            [self calculateMainTanksFuelInUnit:unitId toNewValue:newValue];
            break;
        case FUELAUXTANKS:
            [self calculateAuxTanksFuelInUnit:unitId toNewValue:newValue];
            break;
        case TOTAL:
            break;
            
        case MAXRAMPWEIGHT:
            [self calculateMaxRampInUnit:unitId toNewValue:newValue];
            break;
        case MAXTAKOFWEIGHT:
            [self calculateMaxTakeOffInUnit:unitId toNewValue:newValue];
            break;
        case MAXLANDINGWEIGHT:
            [self calculateMaxLandingInUnit:unitId toNewValue:newValue];
            break;
        case MAXEMPTYFUELWEIGHT:
            [self calculateMaxEmptyFuelWeightInUnit:unitId toNewValue:newValue];
            break;
        case MAXCARGO1WEIGHT:
            [self calculateMaxCargo1InUnit:unitId toNewValue:newValue];
            break;
        case MAXCARGO2WEIGHT:
            [self calculateMaxCargo2InUnit:unitId toNewValue:newValue];
            break;
        case RANGEATMAXGROSSWEIGHT:
            [self calculateCGMaxGrossWeightInUnit:unitId toNewValue:newValue];
            break;
        case RANGEATMAXTAKEOFWEIGHT:
            [self calculateCGMaxTakeOffWeightInUnit:unitId toNewValue:newValue];
            break;
        case RANGEATEMPTYFUELWEIGHT:
            [self calculateCGEmptyFuelWeightInUnit:unitId toNewValue:newValue];
            break;
        case RANGEATBASICEMTYWEIGHT:
            [self calculateCGBasicEmptyWeightInUnit:unitId toNewValue:newValue];
            break;
        case RANGEATMAXGROSSWEIGHT2:
            [self calculateCGMaxGrossWeight2InUnit:unitId toNewValue:newValue];
            break;
        case RANGEATMAXTAKEOFFWEIGHT2:
            [self calculateCGMaxTakeOffWeight2InUnit:unitId toNewValue:newValue];
            break;
        case RANGEATEMPTYFUELWEIGHT2:
            [self calculateCGEmptyFuelWeight2InUnit:unitId toNewValue:newValue];
            break;
        case RANGEATBASICEMPTYWEIGHT2:
            [self calculateCGBasicEmptyWeight2InUnit:unitId toNewValue:newValue];
            break;
        default:
            break;
    }
}

-(void)calculateBasicEmptyWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:101];
    UITextField *armTextField = [self viewWithTag:102];
    UITextField *momentTextField = [self viewWithTag:103];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSUInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateFrontPax1InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:111];
    UITextField *armTextField = [self viewWithTag:112];
    UITextField *momentTextField = [self viewWithTag:113];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSUInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateFrontPax2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:121];
    UITextField *armTextField = [self viewWithTag:122];
    UITextField *momentTextField = [self viewWithTag:123];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSUInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateBackPax1InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:131];
    UITextField *armTextField = [self viewWithTag:132];
    UITextField *momentTextField = [self viewWithTag:133];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ([momentTextField.text doubleValue]>0.00 && ([armTextField.text length]==0 || [armTextField.text doubleValue]<=0.00)) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if ([momentTextField.text doubleValue]>0.00 && ([weightTextField.text length]==0 || [weightTextField.text doubleValue]<=0.00)) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if ([armTextField.text doubleValue]>0.00 && ([weightTextField.text length]==0 || [weightTextField.text doubleValue]<=0.00)) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateBackPax2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:141];
    UITextField *armTextField = [self viewWithTag:142];
    UITextField *momentTextField = [self viewWithTag:143];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSUInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateCargo1InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:151];
    UITextField *armTextField = [self viewWithTag:152];
    UITextField *momentTextField = [self viewWithTag:153];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=newValue;
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    UITextField *maxCargo1TextField = [self viewWithTag:251];
    if (weightValue> [maxCargo1TextField.text doubleValue]) {
        weightTextField.layer.borderColor=[UIColor redColor].CGColor;
    }else {
        weightTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateCargo2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightTextField = [self viewWithTag:161];
    UITextField *armTextField = [self viewWithTag:162];
    UITextField *momentTextField = [self viewWithTag:163];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSInteger currentTag=0;
    switch (unitId) {
        case 1:
            if ( self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=newValue;
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    UITextField *maxCargo2TextField = [self viewWithTag:261];
    if (weightValue> [maxCargo2TextField.text doubleValue]) {
        weightTextField.layer.borderColor=[UIColor redColor].CGColor;
    }else {
        weightTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    [self displayEmptyFuel:currentTag newValue:newValue];
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateMainTanksFuelInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightGalonTextField = [self viewWithTag:181];
    UITextField *weightTextField = [self viewWithTag:182];
    UITextField *armTextField = [self viewWithTag:183];
    UITextField *momentTextField = [self viewWithTag:184];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSInteger currentTag=0;
    switch (unitId) {
        case 1:
            newValue=newValue*6;
            weightValue=newValue;
            if ( self.lastTextFieldTag==momentTextField.tag) {
                
                momentValue=[momentTextField.text doubleValue];
                // weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                // weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            
            if ( self.lastTextFieldTag==momentTextField.tag) {
                
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 4:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    weightGalonTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue/6 uptoDecimal:2]];
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    // [self displayEmptyFuel];
    
    [self displayeTotal:currentTag newValue:newValue];
}
-(void)calculateAuxTanksFuelInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *weightGalonTextField = [self viewWithTag:191];
    UITextField *weightTextField = [self viewWithTag:192];
    UITextField *armTextField = [self viewWithTag:193];
    UITextField *momentTextField = [self viewWithTag:194];
    double weightValue=0.00,armValue=0.00,momentValue=0.00;
    NSInteger currentTag=0;
    switch (unitId) {
        case 1:
            newValue=newValue*6;
            weightValue=newValue;
            if ( self.lastTextFieldTag==momentTextField.tag) {
                
                momentValue=[momentTextField.text doubleValue];
                // weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                // weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 2:
            
            if ( self.lastTextFieldTag==momentTextField.tag) {
                
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[momentTextField.text doubleValue]/newValue;
            }else {
                momentValue=newValue*[armTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
                
            }
            currentTag=weightTextField.tag;
            break;
        case 3:
            if (self.lastTextFieldTag==momentTextField.tag) {
                momentValue=[momentTextField.text doubleValue];
                weightValue=momentValue/[weightTextField.text doubleValue];
                armValue=newValue;
                
            }else {
                momentValue=newValue*[weightTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }
            currentTag=armTextField.tag;
            break;
        case 4:
            if (self.lastTextFieldTag==armTextField.tag) {
                weightValue=newValue/[armTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                armValue=[armTextField.text doubleValue];
            }else {
                armValue=newValue/[weightTextField.text doubleValue];
                momentValue=[momentTextField.text doubleValue];
                weightValue=[weightTextField.text doubleValue];
            }
            currentTag=momentTextField.tag;
        default:
            break;
    }
    UITextField *maxCargo2TextField = [self viewWithTag:221];
    if (weightValue> [maxCargo2TextField.text doubleValue]) {
        weightTextField.layer.borderColor=[UIColor redColor].CGColor;
    }else {
        weightTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }
    weightGalonTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue/6 uptoDecimal:2]];
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:weightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:armValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:momentValue uptoDecimal:2]];
    
    //  [self displayEmptyFuel];
    
    [self displayeTotal:currentTag newValue:newValue];
}

-(void)calculateMaxRampInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:211];
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}
-(void)calculateMaxTakeOffInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:221];
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}
-(void)calculateMaxLandingInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:231];
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}
-(void)calculateMaxEmptyFuelWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:241];
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}
-(void)calculateMaxCargo1InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:251];
    UITextField *cargo1TextField = [self viewWithTag:151];
    if ([cargo1TextField.text doubleValue]> newValue) {
        cargo1TextField.layer.borderColor=[UIColor redColor].CGColor;
    }else {
        cargo1TextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}
-(void)calculateMaxCargo2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *maxRampTextField = [self viewWithTag:261];
    UITextField *cargo2TextField = [self viewWithTag:161];
    if ([cargo2TextField.text doubleValue]> newValue) {
        cargo2TextField.layer.borderColor=[UIColor redColor].CGColor;
    }else {
        cargo2TextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }
    maxRampTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
}




-(void)calculateCGMaxGrossWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:271];
    UITextField *maxTextField = [self viewWithTag:272];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGMaxTakeOffWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:281];
    UITextField *maxTextField = [self viewWithTag:282];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGEmptyFuelWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:291];
    UITextField *maxTextField = [self viewWithTag:292];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGBasicEmptyWeightInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:301];
    UITextField *maxTextField = [self viewWithTag:302];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

-(void)calculateCGMaxGrossWeight2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:311];
    UITextField *maxTextField = [self viewWithTag:312];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGMaxTakeOffWeight2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:321];
    UITextField *maxTextField = [self viewWithTag:322];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGEmptyFuelWeight2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:331];
    UITextField *maxTextField = [self viewWithTag:332];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateCGBasicEmptyWeight2InUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *minTextField = [self viewWithTag:341];
    UITextField *maxTextField = [self viewWithTag:342];
    switch (unitId) {
        case 1:
            minTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        case 2:
            maxTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            break;
        default:
            break;
    }
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}
///-------------------------------------------------
#pragma mark - Utility Methods
///-------------------------------------------------
-(void)displayeTotal:(NSInteger)selectedTag newValue:(double)newValue {
    double totalWeightValue=0.00,totalMomentValue=0.00, cgValue=0.00;
    totalWeightValue= [[(UITextField*)[self viewWithTag:101]text ] doubleValue]+[[(UITextField*)[self viewWithTag:111]text ] doubleValue]+[[(UITextField*)[self viewWithTag:121]text ] doubleValue]+[[(UITextField*)[self viewWithTag:131]text ] doubleValue]+[[(UITextField*)[self viewWithTag:141]text ] doubleValue]+[[(UITextField*)[self viewWithTag:151]text ] doubleValue]+[[(UITextField*)[self viewWithTag:161]text ] doubleValue]+[[(UITextField*)[self viewWithTag:182]text ] doubleValue]+[[(UITextField*)[self viewWithTag:192]text ] doubleValue];
    
    //    totalArmValue= [[(UITextField*)[self viewWithTag:102]text ] doubleValue]+[[(UITextField*)[self viewWithTag:112]text ] doubleValue]+[[(UITextField*)[self viewWithTag:122]text ] doubleValue]+[[(UITextField*)[self viewWithTag:132]text ] doubleValue]+[[(UITextField*)[self viewWithTag:142]text ] doubleValue]+[[(UITextField*)[self viewWithTag:152]text ] doubleValue]+[[(UITextField*)[self viewWithTag:162]text ] doubleValue]+[[(UITextField*)[self viewWithTag:173]text ] doubleValue]+[[(UITextField*)[self viewWithTag:183]text ] doubleValue];;
    totalMomentValue= [[(UITextField*)[self viewWithTag:103]text ] doubleValue]+[[(UITextField*)[self viewWithTag:113]text ] doubleValue]+[[(UITextField*)[self viewWithTag:123]text ] doubleValue]+[[(UITextField*)[self viewWithTag:133]text ] doubleValue]+[[(UITextField*)[self viewWithTag:143]text ] doubleValue]+[[(UITextField*)[self viewWithTag:153]text ] doubleValue]+[[(UITextField*)[self viewWithTag:163]text ] doubleValue]+[[(UITextField*)[self viewWithTag:184]text ] doubleValue]+[[(UITextField*)[self viewWithTag:194]text ] doubleValue];
    if (selectedTag==101 ||selectedTag==111 ||selectedTag==121 ||selectedTag==131 ||selectedTag==141 ||selectedTag==151 ||selectedTag==161 ||selectedTag==182 || selectedTag==192) {
        totalWeightValue=totalWeightValue-[[(UITextField*)[self viewWithTag:selectedTag]text ] doubleValue]+newValue;
    }
    else if (selectedTag==103 ||selectedTag==113 ||selectedTag==123 ||selectedTag==133 ||selectedTag==143 ||selectedTag==153 ||selectedTag==163 ||selectedTag==184 || selectedTag==194) {
        totalMomentValue=totalMomentValue-[[(UITextField*)[self viewWithTag:selectedTag]text ] doubleValue]+newValue;
    }
    cgValue=totalMomentValue/totalWeightValue;
    
    UITextField *weightTextField=[self viewWithTag:201];
    UITextField *armTextField=[self viewWithTag:202];
    
    UITextField *momentTextField=[self viewWithTag:203];
    UITextField *emptyFuleMoment = [self viewWithTag:173];
    UITextField *maxGrossWait = [self viewWithTag:272];
    UITextField *minGrossWait = [self viewWithTag:271];
    
    if ([minGrossWait.text doubleValue] <= [momentTextField.text doubleValue] && [maxGrossWait.text doubleValue] >= [momentTextField.text doubleValue]) {
        momentTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }else
    {
        momentTextField.layer.borderColor=[UIColor redColor].CGColor;
    }
    if ([minGrossWait.text doubleValue] <= [emptyFuleMoment.text doubleValue] && [maxGrossWait.text doubleValue] >= [emptyFuleMoment.text doubleValue]) {
        emptyFuleMoment.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
    }else
    {
        emptyFuleMoment.layer.borderColor=[UIColor redColor].CGColor;
    }
    UITextField *minEmptyFuelweigtTextField=[self viewWithTag:311];
    UITextField *maxEmptyFuelweigtTextField=[self viewWithTag:312];
    if ([minEmptyFuelweigtTextField.text doubleValue]>0.0 && [maxEmptyFuelweigtTextField.text doubleValue]>0.0) {
        if (totalMomentValue>= [minEmptyFuelweigtTextField.text doubleValue] && totalMomentValue<= [maxEmptyFuelweigtTextField.text doubleValue]) {
            weightTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        }else {
            weightTextField.layer.borderColor=[UIColor redColor].CGColor;
        }
    }
    
    
    
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:totalWeightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:cgValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:totalMomentValue uptoDecimal:2]];
    
    //[self drawGraphValue:selectedTag newValue:[NSString stringWithFormat:@"%.02f",newValue]];
    
}

- (void)drawGraphValue:(NSInteger)selectedTag newValue:(NSString*)newValue
{
    [_momentGraph removeFromSuperview];
    _momentGraph=[[TMLineGraph alloc] initWithFrame:CGRectMake(400, 1800, 280, 240)];
    [self.shapeLayerGraphUtility removeFromSuperlayer];
    [self.shapeLayerGraph removeFromSuperlayer];
    [self.shapeLayerGraphLine removeFromSuperlayer];
     [self.shapeLayerRedLine removeFromSuperlayer];
    self.shapeLayerRedLine=[CAShapeLayer layer];
    self.shapeLayerGraphLine = [CAShapeLayer layer];
    self.shapeLayerGraph = [CAShapeLayer layer];
    self.shapeLayerGraphUtility = [CAShapeLayer layer];
    NSMutableArray *arrayMinGraph=[[NSMutableArray alloc] init];
    NSMutableArray *weightArray= [[NSMutableArray alloc]init];
    NSMutableArray *cgArray= [[NSMutableArray alloc]init];
    
    NSMutableArray *arrayMinGraphUtility= [[NSMutableArray alloc]init];
    if ([[(UITextField *)[self viewWithTag:211] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:271] text] doubleValue] > 0) {
       
            [arrayMinGraph addObject:[NSString stringWithFormat:@"%@:%@",selectedTag==211? newValue:[(UITextField *)[self viewWithTag:211] text],selectedTag==271?newValue:[(UITextField *)[self viewWithTag:271] text]]];
            [weightArray addObject:selectedTag==211? newValue:[(UITextField *)[self viewWithTag:211] text]];
            [cgArray addObject:selectedTag==211? newValue:[(UITextField *)[self viewWithTag:271] text]];
       
       
       
    }
    
    if ([[(UITextField *)[self viewWithTag:221] text] doubleValue] > 0 && [[(UITextField *)[self viewWithTag:281] text] doubleValue] > 0) {
        [arrayMinGraph addObject:[NSString stringWithFormat:@"%@:%@", selectedTag==221? newValue:[(UITextField *)[self viewWithTag:221] text],selectedTag==281? newValue:[(UITextField *)[self viewWithTag:281] text]]];
        [weightArray addObject:selectedTag==221? newValue:[(UITextField *)[self viewWithTag:221] text]];
        [cgArray addObject:selectedTag==281? newValue:[(UITextField *)[self viewWithTag:281] text]];
    }
    
    if ([[(UITextField *)[self viewWithTag:241] text] doubleValue] > 0 && [[(UITextField *)[self viewWithTag:291] text]doubleValue] > 0) {
        [arrayMinGraph addObject:[NSString stringWithFormat:@"%@:%@",selectedTag==241? newValue: [(UITextField *)[self viewWithTag:241] text],selectedTag==291? newValue:[(UITextField *)[self viewWithTag:291] text]]];
        [weightArray addObject:selectedTag==241? newValue:[(UITextField *)[self viewWithTag:241] text]];
        [cgArray addObject:selectedTag==291? newValue:[(UITextField *)[self viewWithTag:291] text]];
    }
    if ([[(UITextField *)[self viewWithTag:101] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:301] text]doubleValue] > 0) {
        [arrayMinGraph addObject:[NSString stringWithFormat:@"%@:%@", selectedTag==101? newValue:[(UITextField *)[self viewWithTag:101] text],selectedTag==301? newValue:[(UITextField *)[self viewWithTag:301] text]]];
        [weightArray addObject:selectedTag==101? newValue:[(UITextField *)[self viewWithTag:101] text]];
        [cgArray addObject:selectedTag==301? newValue:[(UITextField *)[self viewWithTag:301] text]];
    }
    
    
    
    /** Utility Min **/
    if ([[(UITextField *)[self viewWithTag:211] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:311] text] doubleValue] > 0) {
        [arrayMinGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:211] text],[(UITextField *)[self viewWithTag:311] text]]];
        //[cgArrayUtility addObject:[(UITextField *)[self viewWithTag:311] text]];
    }
    
    if ([[(UITextField *)[self viewWithTag:221] text] doubleValue] > 0 && [[(UITextField *)[self viewWithTag:321] text] doubleValue] > 0) {
        [arrayMinGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:221] text],[(UITextField *)[self viewWithTag:321] text]]];
        //[cgArrayUtility addObject:[(UITextField *)[self viewWithTag:321] text]];
    }
    
    if ([[(UITextField *)[self viewWithTag:241] text] doubleValue] > 0 && [[(UITextField *)[self viewWithTag:331] text]doubleValue] > 0) {
        [arrayMinGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:241] text],[(UITextField *)[self viewWithTag:331] text]]];
        //[cgArrayUtility addObject:[(UITextField *)[self viewWithTag:331] text]];
    }
    if ([[(UITextField *)[self viewWithTag:101] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:341] text]doubleValue] > 0) {
        [arrayMinGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:101] text],[(UITextField *)[self viewWithTag:341] text]]];
        //[cgArrayUtility addObject:[(UITextField *)[self viewWithTag:341] text]];
    }
    /** Utility Min End **/
    
    
    if (arrayMinGraph.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        arrayMinGraph= [[arrayMinGraph sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    if (arrayMinGraphUtility.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        arrayMinGraphUtility= [[arrayMinGraphUtility sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    NSMutableArray *arrayMaxGraph=[[NSMutableArray alloc] init];
    if ([[(UITextField *)[self viewWithTag:211] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:272] text]doubleValue] > 0) {
        [arrayMaxGraph addObject:selectedTag==211? newValue:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:211] text],selectedTag==272? newValue:[(UITextField *)[self viewWithTag:272] text]]];
        [cgArray addObject:selectedTag==272? newValue:[(UITextField *)[self viewWithTag:272] text]];
    }
    
    if ([[(UITextField *)[self viewWithTag:221] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:282] text]doubleValue] > 0) {
        [arrayMaxGraph addObject:[NSString stringWithFormat:@"%@:%@",selectedTag==221? newValue: [(UITextField *)[self viewWithTag:221] text],selectedTag==282? newValue:[(UITextField *)[self viewWithTag:282] text]]];
        [cgArray addObject:selectedTag==282? newValue:[(UITextField *)[self viewWithTag:282] text]];
    }
    if ([[(UITextField *)[self viewWithTag:241] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:292] text]doubleValue] > 0) {
        [arrayMaxGraph addObject:[NSString stringWithFormat:@"%@:%@",selectedTag==241? newValue: [(UITextField *)[self viewWithTag:241] text],selectedTag==292? newValue:[(UITextField *)[self viewWithTag:292] text]]];
        [cgArray addObject:selectedTag==292? newValue:[(UITextField *)[self viewWithTag:292] text]];
    }
    if ([[(UITextField *)[self viewWithTag:101] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:302] text]doubleValue] > 0) {
        [arrayMaxGraph addObject:[NSString stringWithFormat:@"%@:%@",selectedTag==101? newValue: [(UITextField *)[self viewWithTag:101] text],selectedTag==302? newValue:[(UITextField *)[self viewWithTag:302] text]]];
        [cgArray addObject:selectedTag==302? newValue:[(UITextField *)[self viewWithTag:302] text]];
    }
    
    
    /** Utility Max **/
    NSMutableArray *arrayMaxGraphUtility=[[NSMutableArray alloc] init];
    if ([[(UITextField *)[self viewWithTag:211] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:312] text]doubleValue] > 0) {
        [arrayMaxGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:211] text],[(UITextField *)[self viewWithTag:312] text]]];
    }
    
    if ([[(UITextField *)[self viewWithTag:221] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:322] text]doubleValue] > 0) {
        [arrayMaxGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:221] text],[(UITextField *)[self viewWithTag:322] text]]];
    }
    if ([[(UITextField *)[self viewWithTag:241] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:332] text] doubleValue]> 0) {
        [arrayMaxGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:241] text],[(UITextField *)[self viewWithTag:332] text]]];
    }
    if ([[(UITextField *)[self viewWithTag:101] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:342] text]doubleValue] > 0) {
        [arrayMaxGraphUtility addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:101] text],[(UITextField *)[self viewWithTag:342] text]]];
    }
    
    if (arrayMaxGraph.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        arrayMaxGraph= [[arrayMaxGraph sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    
    NSMutableArray *arrayArmGraph=[[NSMutableArray alloc] init];
    [arrayArmGraph addObjectsFromArray:arrayMinGraph];
    [arrayArmGraph addObjectsFromArray:arrayMaxGraph];
    
    
    
    
    
    if (arrayMaxGraphUtility.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        arrayMaxGraphUtility= [[arrayMaxGraphUtility sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
    
    
    NSMutableArray *arrayArmGraphUtility=[[NSMutableArray alloc] init];
    [arrayArmGraphUtility addObjectsFromArray:arrayMinGraphUtility];
    [arrayArmGraphUtility addObjectsFromArray:arrayMaxGraphUtility];
    
    if (weightArray.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        weightArray= [[weightArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        [_momentGraph addVerticalLabel:weightArray];
    }
    if (cgArray.count > 0) {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        cgArray= [[cgArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        //[_momentGraph addHorizontalLabel:@[@"100",@"120",@"140",@"160",@"180",@"200",@"220"]];
        [_momentGraph addHorizontalLabel:cgArray];
    }
    
    
    
    [self.containerView addSubview:_momentGraph];
    if (arrayArmGraph.count > 0) {
        [arrayArmGraph addObject:[arrayArmGraph firstObject]];
        [_momentGraph drawGraph:arrayArmGraph color:[UIColor blackColor] shapeLayer:self.shapeLayerGraph];
       // [_momentGraph drawGraph:@[@"3600:143.2",@"3550:143.0",@"3400:142.5",@"2456:138.5",@"2456:147.0",@"3400:148.7",@"3550:148.0",@"3600:148.5",@"3600:143.2"]];
    }
    
    /** Draw CG Utility Graph**/
    
    if (arrayArmGraphUtility.count > 0) {
        [arrayArmGraphUtility addObject:[arrayArmGraphUtility firstObject]];
        [_momentGraph drawGraph:arrayArmGraphUtility color:[UIColor greenColor] shapeLayer:self.shapeLayerGraphUtility];
        // [_momentGraph drawGraph:@[@"3600:143.2",@"3550:143.0",@"3400:142.5",@"2456:138.5",@"2456:147.0",@"3400:148.7",@"3550:148.0",@"3600:148.5",@"3600:143.2"]];
    }
    /** Draw BlueLine Graph**/
    NSMutableArray *arrayBlueGraph=[[NSMutableArray alloc] init];
    if ([[(UITextField *)[self viewWithTag:171] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:172] text]doubleValue] > 0) {
        [arrayBlueGraph addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:171] text],[(UITextField *)[self viewWithTag:172] text]]];
    }
    
    if ([[(UITextField *)[self viewWithTag:201] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:202] text]doubleValue] > 0) {
        [arrayBlueGraph addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:201] text],[(UITextField *)[self viewWithTag:202] text]]];
    }
    if (arrayBlueGraph.count > 0 && [[arrayBlueGraph firstObject]doubleValue] < [[weightArray lastObject]doubleValue]) {
        [_momentGraph drawGraph:arrayBlueGraph color:[UIColor blueColor] shapeLayer:self.shapeLayerGraphLine];
    }
    
     /** Draw RedLine Graph**/
    NSMutableArray *arrayRedGraph=[[NSMutableArray alloc] init];
    if ([[(UITextField *)[self viewWithTag:241] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:291] text]doubleValue] > 0) {
        [arrayRedGraph addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:241] text],[(UITextField *)[self viewWithTag:291] text]]];
    }
    
    if ([[(UITextField *)[self viewWithTag:241] text]doubleValue] > 0 && [[(UITextField *)[self viewWithTag:292] text]doubleValue] > 0) {
        [arrayRedGraph addObject:[NSString stringWithFormat:@"%@:%@", [(UITextField *)[self viewWithTag:241] text],[(UITextField *)[self viewWithTag:292] text]]];
    }
    if (arrayRedGraph.count > 0 && [[arrayRedGraph firstObject]doubleValue] < [[weightArray lastObject]doubleValue]) {
        [_momentGraph drawGraph:arrayRedGraph color:[UIColor redColor] shapeLayer:self.shapeLayerRedLine];
    }
}
-(void)displayEmptyFuel:(NSInteger)selectedTag newValue:(double)newValue {
    double totalWeightValue=0.00,totalMomentValue=0.00, cgValue=0.00;
    totalWeightValue= [[(UITextField*)[self viewWithTag:101]text ] doubleValue]+[[(UITextField*)[self viewWithTag:111]text ] doubleValue]+[[(UITextField*)[self viewWithTag:121]text ] doubleValue]+[[(UITextField*)[self viewWithTag:131]text ] doubleValue]+[[(UITextField*)[self viewWithTag:141]text ] doubleValue]+[[(UITextField*)[self viewWithTag:151]text ] doubleValue]+[[(UITextField*)[self viewWithTag:161]text ] doubleValue];
    
    //    totalArmValue= [[(UITextField*)[self viewWithTag:102]text ] doubleValue]+[[(UITextField*)[self viewWithTag:112]text ] doubleValue]+[[(UITextField*)[self viewWithTag:122]text ] doubleValue]+[[(UITextField*)[self viewWithTag:132]text ] doubleValue]+[[(UITextField*)[self viewWithTag:142]text ] doubleValue]+[[(UITextField*)[self viewWithTag:152]text ] doubleValue]+[[(UITextField*)[self viewWithTag:162]text ] doubleValue];
    
    totalMomentValue= [[(UITextField*)[self viewWithTag:103]text ] doubleValue]+[[(UITextField*)[self viewWithTag:113]text ] doubleValue]+[[(UITextField*)[self viewWithTag:123]text ] doubleValue]+[[(UITextField*)[self viewWithTag:133]text ] doubleValue]+[[(UITextField*)[self viewWithTag:143]text ] doubleValue]+[[(UITextField*)[self viewWithTag:153]text ] doubleValue]+[[(UITextField*)[self viewWithTag:163]text ] doubleValue];
    if (selectedTag==101 ||selectedTag==111 ||selectedTag==121 ||selectedTag==131 ||selectedTag==141 ||selectedTag==151 ||selectedTag==161 ) {
        totalWeightValue=totalWeightValue-[[(UITextField*)[self viewWithTag:selectedTag]text ] doubleValue]+newValue;
    }
    else if (selectedTag==103 ||selectedTag==113 ||selectedTag==123 ||selectedTag==133 ||selectedTag==143 ||selectedTag==153 ||selectedTag==163 ) {
        totalMomentValue=totalMomentValue-[[(UITextField*)[self viewWithTag:selectedTag]text ] doubleValue]+newValue;
    }
    cgValue=totalMomentValue/totalWeightValue;
    
    UITextField *weightTextField=[self viewWithTag:171];
    UITextField *armTextField=[self viewWithTag:172];
    UITextField *momentTextField=[self viewWithTag:173];
    
    UITextField *maxFuelweigtTextField=[self viewWithTag:241];
    UITextField *minEmptyFuelweigtTextField=[self viewWithTag:291];
    UITextField *maxEmptyFuelweigtTextField=[self viewWithTag:292];
    if ([maxFuelweigtTextField.text doubleValue]>0.0) {
        if (totalWeightValue> [maxFuelweigtTextField.text doubleValue]) {
            weightTextField.layer.borderColor=[UIColor redColor].CGColor;
        }else {
            weightTextField.layer.borderColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        }
    }
  
    
    weightTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:totalWeightValue uptoDecimal:2]];
    armTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:cgValue uptoDecimal:2]];
    momentTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:totalMomentValue uptoDecimal:2]];
    
    
}

-(double)getdecimalTimeFromString:(NSString*)time {
    NSArray *seperateString;
    double hours=0.00;
    double minutes=0.00;
    double second=0.00;
    if ([time containsString:@":"]) {
        seperateString=[time componentsSeparatedByString:@":"];
    }
    if ([seperateString count]==0) {
        hours=[time doubleValue];
    }
    else if ([seperateString count]==1) {
        hours=[seperateString[0] doubleValue];
    }
    else if ([seperateString count]==2) {
        hours=[seperateString[0] doubleValue];
        minutes=[seperateString[1] doubleValue];
    }
    else if ([seperateString count]==3) {
        hours=[seperateString[0] doubleValue];
        minutes=[seperateString[1] doubleValue];
        second=[seperateString[2] doubleValue];
    }
    minutes=minutes/60;
    return hours+minutes+second;
}
- (double)getRoundedForValue:(double)value uptoDecimal:(int)decimalPlaces{
    int divisor = pow(10, decimalPlaces);
    NSLog(@"%.02f",roundf(value * divisor) / divisor);
    return roundf(value * divisor) / divisor;
}


///-------------------------------------------------
#pragma mark - Clear Button Action
///-------------------------------------------------
- (IBAction)clearBaseEmptyWeight:(id)sender {
    ((UITextField *)[self viewWithTag:101]).text = @"";
    ((UITextField *)[self viewWithTag:102]).text = @"";
    ((UITextField *)[self viewWithTag:103]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearFrontPax1:(id)sender {
    ((UITextField *)[self viewWithTag:111]).text = @"";
    ((UITextField *)[self viewWithTag:112]).text = @"";
    ((UITextField *)[self viewWithTag:113]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearFrontPax2:(id)sender {
    ((UITextField *)[self viewWithTag:121]).text = @"";
    ((UITextField *)[self viewWithTag:122]).text = @"";
    ((UITextField *)[self viewWithTag:123]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearBackPax1:(id)sender {
    ((UITextField *)[self viewWithTag:131]).text = @"";
    ((UITextField *)[self viewWithTag:132]).text = @"";
    ((UITextField *)[self viewWithTag:133]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearBackPax2:(id)sender {
    ((UITextField *)[self viewWithTag:141]).text = @"";
    ((UITextField *)[self viewWithTag:142]).text = @"";
    ((UITextField *)[self viewWithTag:143]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearCargo1:(id)sender {
    ((UITextField *)[self viewWithTag:151]).text = @"";
    ((UITextField *)[self viewWithTag:152]).text = @"";
    ((UITextField *)[self viewWithTag:153]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearCargo2:(id)sender {
    ((UITextField *)[self viewWithTag:161]).text = @"";
    ((UITextField *)[self viewWithTag:162]).text = @"";
    ((UITextField *)[self viewWithTag:163]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearEmptyFuel:(id)sender {
    ((UITextField *)[self viewWithTag:171]).text = @"";
    ((UITextField *)[self viewWithTag:172]).text = @"";
    ((UITextField *)[self viewWithTag:173]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearMainTanks:(id)sender {
    ((UITextField *)[self viewWithTag:181]).text = @"";
    ((UITextField *)[self viewWithTag:182]).text = @"";
    ((UITextField *)[self viewWithTag:183]).text = @"";
    ((UITextField *)[self viewWithTag:184]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearFuelAuxTanks:(id)sender {
    ((UITextField *)[self viewWithTag:191]).text = @"";
    ((UITextField *)[self viewWithTag:192]).text = @"";
    ((UITextField *)[self viewWithTag:193]).text = @"";
    ((UITextField *)[self viewWithTag:194]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearGrossRampWeight:(id)sender {
    ((UITextField *)[self viewWithTag:211]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
    
}

- (IBAction)clearMaxTakeOffWeight:(id)sender {
    ((UITextField *)[self viewWithTag:221]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearMaxLandingWeight:(id)sender {
    ((UITextField *)[self viewWithTag:231]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearMaxEmptyFuelWeight:(id)sender {
    ((UITextField *)[self viewWithTag:241]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearMaxCargo1Weight:(id)sender {
    ((UITextField *)[self viewWithTag:251]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearMaxCargo2Weight:(id)sender {
    ((UITextField *)[self viewWithTag:261]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtMAXGrossWeight:(id)sender {
    ((UITextField *)[self viewWithTag:271]).text = @"";
    ((UITextField *)[self viewWithTag:272]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtMAXTakeOffWeight:(id)sender {
    ((UITextField *)[self viewWithTag:281]).text = @"";
    ((UITextField *)[self viewWithTag:282]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtEmptyFuelWeight:(id)sender {
    ((UITextField *)[self viewWithTag:291]).text = @"";
    ((UITextField *)[self viewWithTag:292]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtBasicEmptyWeight:(id)sender {
    ((UITextField *)[self viewWithTag:301]).text = @"";
    ((UITextField *)[self viewWithTag:302]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtMAXGrossWeight2:(id)sender {
    ((UITextField *)[self viewWithTag:311]).text = @"";
    ((UITextField *)[self viewWithTag:312]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtMAXTakeOffWeight2:(id)sender {
    ((UITextField *)[self viewWithTag:321]).text = @"";
    ((UITextField *)[self viewWithTag:322]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtEmptyFuelWeight2:(id)sender {
    ((UITextField *)[self viewWithTag:331]).text = @"";
    ((UITextField *)[self viewWithTag:332]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}

- (IBAction)clearRangeAtBasicEmptyWeight2:(id)sender {
    ((UITextField *)[self viewWithTag:341]).text = @"";
    ((UITextField *)[self viewWithTag:342]).text = @"";
    [self displayEmptyFuel:0 newValue:0];
    [self displayeTotal:0 newValue:0];
}






#pragma mark Table View Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayFiles count];    //count number of row from counting array hear cataGorry is An Array
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    WeightBalance *balance=self.arrayFiles[indexPath.row];
    
    UITextField *saveTxt = [[UITextField alloc]init];
    saveTxt.borderStyle=UITextBorderStyleRoundedRect;
    saveTxt.frame = CGRectMake(0.0, 0.0, self.saveTableView.bounds.size.width, 30.0);
    saveTxt.textAlignment = NSTextAlignmentCenter;
    saveTxt.userInteractionEnabled = NO;
    saveTxt.text = balance.name;
    [cell.contentView addSubview:saveTxt];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSaveFileSelected == NO) {
        self.isSaveFileSelected = YES;
        [self actionSave:nil];
    }
    WeightBalance *balance=self.arrayFiles[indexPath.row];
    [self displayDetails:balance];
    self.wtClearBackBtn.hidden = NO;
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBackButton" object:nil userInfo:@{@"isBackShow":[NSNumber numberWithBool:YES]}];
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        WeightBalance *balance=self.arrayFiles[indexPath.row];
        [self deleteFile:balance];
    }
}

-(void)displayDetails:(WeightBalance*)balance {
    ((UITextField *)[self viewWithTag:101]).text=[balance.basicEmptyWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.basicEmptyWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:102]).text=[balance.basicEmptyArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.basicEmptyArm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:103]).text=[balance.basicEmptyMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.basicEmptyMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:111]).text=[balance.frontPaxWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPaxWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:112]).text =[balance.frontPaxArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPaxArm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:113]).text=[balance.frontPaxMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPaxMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:121]).text=[balance.frontPax2Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPax2Weight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:122]).text=[balance.frontPax2Arm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPax2Arm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:123]).text=[balance.frontPax2Moment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.frontPax2Moment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:131]).text=[balance.backPaxWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.backPaxWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:132]).text=[balance.backPaxArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.backPaxArm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:133]).text=[balance.backPaxMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.backPaxMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:141]).text= [balance.backPax2Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.backPax2Weight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:142]).text=[balance.backPax2Arm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.backPax2Arm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:143]).text=[balance.backPax2Moment doubleValue]==0?@"":[NSString stringWithFormat:@"%.02f", [balance.backPax2Moment doubleValue]];
    ((UITextField *)[self viewWithTag:151]).text=[balance.cargo1Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo1Weight doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:152]).text=[balance.cargo1Arm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo1Arm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:153]).text=[balance.cargo1Moment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo1Moment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:161]).text=[balance.cargo2Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo2Weight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:162]).text=[balance.cargo2Arm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo2Arm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:163]).text=[balance.cargo2Moment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cargo2Moment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:171]).text=[balance.emptyFuelWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.emptyFuelWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:172]).text=[balance.emptyFuelArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.emptyFuelArm doubleValue]]:@"" ;
    ((UITextField *)[self viewWithTag:173]).text=[balance.emptyFuelMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.emptyFuelMoment doubleValue]]:@"" ;
    ((UITextField *)[self viewWithTag:181]).text=[balance.mainTanksWeightGl doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.mainTanksWeightGl doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:182]).text=[balance.mainTanksWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.mainTanksWeight doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:183]).text=[balance.mainTanksArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.mainTanksArm doubleValue]]:@"";
    ;
    ((UITextField *)[self viewWithTag:184]).text=[balance.mainTanksMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.mainTanksMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:191]).text=[balance.auxTankWeightGl doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.auxTankWeightGl doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:192]).text=[balance.auxTankweight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f", [balance.auxTankweight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:193]).text=[balance.auxTankArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.auxTankArm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:194]).text=[balance.auxTankMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.auxTankMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:201]).text=[balance.totalWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.totalWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:202]).text=[balance.totalArm doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.totalArm doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:203]).text=[balance.totalMoment doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.totalMoment doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:211]).text=[balance.maxGrossWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxGrossWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:221]).text=[balance.maxTakeOffWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxTakeOffWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:231]).text=[balance.maxLandingWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxLandingWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:241]).text=[balance.maxEmptyFuelWeight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxEmptyFuelWeight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:251]).text=[balance.maxCargo1Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxCargo1Weight doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:261]).text=[balance.maxCargo2Weight doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.maxCargo2Weight doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:271]).text=[balance.cgGrossWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgGrossWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:272]).text=[balance.cgGrossWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgGrossWeightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:281]).text=[balance.cgTakeOffWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgTakeOffWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:282]).text=[balance.cgTakeOffweightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgTakeOffweightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:291]).text=[balance.cgEmptyFuelWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgEmptyFuelWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:292]).text=[balance.cgEmptyFuelWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgEmptyFuelWeightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:301]).text=[balance.cgBasicEmptyWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgBasicEmptyWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:302]).text=[balance.cgBasicEmptyWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cgBasicEmptyWeightMax doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:311]).text=[balance.cg2GrossWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2GrossWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:312]).text=[balance.cg2GrossWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2GrossWeightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:321]).text=[balance.cg2TakeOffweightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2TakeOffweightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:322]).text=[balance.cg2TakeOffweightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2TakeOffweightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:331]).text=[balance.cg2EmptyFuelWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2EmptyFuelWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:332]).text=[balance.cg2EmptyFuelWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2EmptyFuelWeightMax doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:341]).text=[balance.cg2BasicEmptyWeightMin doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2BasicEmptyWeightMin doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:342]).text=[balance.cg2BasicEmptyWeightMax doubleValue]>0.0?[NSString stringWithFormat:@"%.02f",[balance.cg2BasicEmptyWeightMax doubleValue]]:@"";
    
    
    [self drawGraphValue:0 newValue:0];
    
}
-(void)deleteFile:(WeightBalance*)balance {
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [[appDelegate getContext] deleteObject:balance];
    NSError *error;
    [[appDelegate getContext] save:&error];
    if (!error) {
        [self.arrayFiles removeObject:balance];
        [self.saveTableView reloadData];
    }
}

-(void)getSavedFiles {
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context=[appDelegate getContext];
    
    NSEntityDescription *descriptor=[NSEntityDescription entityForName:ENTITY_WEIGHTBALANCE inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init] ;
    //    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES]]];
    [request setEntity:descriptor];
    
    NSError *error;
    NSArray *fetchedData = [context executeFetchRequest:request error:&error];
    [self.arrayFiles removeAllObjects];
    if ([fetchedData count]>0) {
        
        [self.arrayFiles addObjectsFromArray:[fetchedData mutableCopy]];
    }
    [self.saveTableView reloadData];
    
}
-(BOOL)exist
{
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext=[appDelegate getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_WEIGHTBALANCE inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", self.txtFieldName.text]];
    
    NSError *error = nil;
    NSUInteger count = [managedObjectContext countForFetchRequest:request error:&error];
    
    if (count)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (IBAction)actionSave:(id)sender {
    
    if ([self.txtFieldName.text length]>0 || self.isSaveFileSelected == YES) {
        if (![self exist]) {
        AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context=[appDelegate getContext];
        NSEntityDescription *descriptor=[NSEntityDescription entityForName:ENTITY_WEIGHTBALANCE inManagedObjectContext:context];
        WeightBalance *balance=[[WeightBalance alloc] initWithEntity:descriptor insertIntoManagedObjectContext:context];
        balance.name=self.txtFieldName.text;
        balance.basicEmptyWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:101]).text doubleValue]];
        balance.basicEmptyArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:102]).text doubleValue]];
        balance.basicEmptyMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:103]).text doubleValue]];
        balance.frontPaxWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:111]).text doubleValue]];
        balance.frontPaxArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:112]).text doubleValue]];
        balance.frontPaxMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:113]).text doubleValue]];
        balance.frontPax2Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:121]).text doubleValue]];
        balance.frontPax2Arm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:122]).text doubleValue]];
        balance.frontPax2Moment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:123]).text doubleValue]];
        balance.backPaxWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:131]).text doubleValue]];
        balance.backPaxArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:132]).text doubleValue]];
        balance.backPaxMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:133]).text doubleValue]];
        balance.backPax2Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:141]).text doubleValue]];
        balance.backPax2Arm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:142]).text doubleValue]];
        balance.backPax2Moment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:143]).text doubleValue]];
        balance.cargo1Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:151]).text doubleValue]];
        balance.cargo1Arm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:152]).text doubleValue]];
        balance.cargo1Moment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:153]).text doubleValue]];
        balance.cargo2Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:161]).text doubleValue]];
        balance.cargo2Arm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:162]).text doubleValue]];
        balance.cargo2Moment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:163]).text doubleValue]];
        balance.emptyFuelWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:171]).text doubleValue]];
        balance.emptyFuelArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:172]).text doubleValue]];
        balance.emptyFuelMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:173]).text doubleValue]];
        balance.mainTanksWeightGl=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:181]).text doubleValue]];
        balance.mainTanksWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:182]).text doubleValue]];
        balance.mainTanksArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:183]).text doubleValue]];
        balance.mainTanksMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:184]).text doubleValue]];
        balance.auxTankWeightGl=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:191]).text doubleValue]];
        balance.auxTankweight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:192]).text doubleValue]];
        balance.auxTankArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:193]).text doubleValue]];
        balance.auxTankMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:194]).text doubleValue]];
        balance.totalWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:201]).text doubleValue]];
        balance.totalArm=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:202]).text doubleValue]];
        balance.totalMoment=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:203]).text doubleValue]];
        balance.maxGrossWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:211]).text doubleValue]];
        balance.maxTakeOffWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:221]).text doubleValue]];
        balance.maxLandingWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:231]).text doubleValue]];
        balance.maxEmptyFuelWeight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:241]).text doubleValue]];
        balance.maxCargo1Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:251]).text doubleValue]];
        balance.maxCargo2Weight=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:261]).text doubleValue]];
        
        balance.cgGrossWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:271]).text doubleValue]];
        balance.cgGrossWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:272]).text doubleValue]];
        balance.cgTakeOffWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:281]).text doubleValue]];
        balance.cgTakeOffweightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:282]).text doubleValue]];
        balance.cgEmptyFuelWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:291]).text doubleValue]];
        balance.cgEmptyFuelWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:292]).text doubleValue]];
        balance.cgBasicEmptyWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:301]).text doubleValue]];
        balance.cgBasicEmptyWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:302]).text doubleValue]];
        
        balance.cg2GrossWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:311]).text doubleValue]];
        balance.cg2GrossWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:312]).text doubleValue]];
        balance.cg2TakeOffweightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:321]).text doubleValue]];
        balance.cg2TakeOffweightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:322]).text doubleValue]];
        balance.cg2EmptyFuelWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:331]).text doubleValue]];
        balance.cg2EmptyFuelWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:332]).text doubleValue]];
        balance.cg2BasicEmptyWeightMin=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:341]).text doubleValue]];
        balance.cg2BasicEmptyWeightMax=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:342]).text doubleValue]];
        if (_isSaveFileSelected == NO) {
            NSError *error;
            [context save:&error];
            if (!error) {
                [self.arrayFiles addObject:balance];
                self.txtFieldName.text=@"";
            }
            [self.saveTableView reloadData];
        }else
        {
            self.wtTextValue = balance;
        }
        
        }else if(self.isSaveFileSelected == NO){
            [self displayAlertWithMessage:@"File name already exist."];
        }

}
    
    
}
- (IBAction)actionClearAll:(id)sender {
    [self clearText:nil];
}
-(void)displayAlertWithMessage:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@""
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    
    [alert addAction:ok];
    UIViewController *VC=[self.window rootViewController];
    [VC presentViewController:alert animated:YES completion:nil];
}

@end

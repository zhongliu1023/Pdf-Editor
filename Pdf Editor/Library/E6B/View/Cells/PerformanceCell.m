//
//  PerformanceCell.m
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import "PerformanceCell.h"
#define ACCEPTABLE_CHARECTERS @"-0123456789."
#define ACCEPTABLE_TIMECHARECTERS @"-0123456789:"

@interface PerformanceCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

typedef enum : NSUInteger {
    FIRSTROW = 10,
    SECONDROW,
    THIRDROW,
    FOURTHROW,
    FIFTHROW,
    SIXTHROW,
    SEVENTHROW,
    EIGHTHROW,
    NINETHROW,
    TENTHROW,
    ELEVENTHROW,
    TWELVETHROW,
    THIRTEENTHROW,
    FOURTEENTHROW,
    FIFTEENTHROW,
    SIXTEENTHROW,
    SEVENTEENTHROW
   
} PerformanceMeasurement;

@implementation PerformanceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnClearAll.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // you probably want to center it
    self.btnClearAll.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    [self.btnClearAll setTitle: @"CLEAR ALL" forState: UIControlStateNormal];
    
//    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.containerView.layer.borderWidth = 1.0;
    
    
    for (UIView *subView in self.containerView.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subView;
                
                if ([textField isUserInteractionEnabled]) {
                    textField.layer.cornerRadius=5.0;
                    textField.layer.borderWidth=1.0;
                    textField.borderStyle=UITextBorderStyleNone;
                    textField.textColor = [UIColor blueColor];
                    textField.layer.borderColor=[UIColor blueColor].CGColor;
                    [textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
                }else
                    textField.textColor=[UIColor blackColor];
               
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.delegate = self;
                //                textField.placeholder = @"0.00";
            }
            
            if ([subView isKindOfClass:[UIButton class]]) {
                // Adding rounded corner to button
                UIButton *button = (UIButton *)subView;
                
                button.layer.cornerRadius = 10;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor blueColor].CGColor;
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionClearAll:) name:@"ClearText" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)clearText {
    for (UITextField *subView in self.containerView.subviews) {
       
    if ([subView isKindOfClass:[UITextField class]]) {

     subView.text=@"";
    }
       
    }
}
///-------------------------------------------------
#pragma mark - ActionMethods
///-------------------------------------------------

- (IBAction)actionClearAll:(id)sender {
    [self clearText];
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
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag!=1020) {
        NSString *acceptableCharacter=ACCEPTABLE_CHARECTERS;
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacter] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:[string isEqualToString:filtered]?string:@""];
        if (([string isEqualToString:@"."] || [string isEqualToString:@"-"])  && range.length<1) {
            if ([string isEqualToString:@"."] && [textField.text containsString:@"."]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }else if ([string isEqualToString:@"-"] && [textField.text containsString:@"-"]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }
        }
        
        double newValue=[finalString doubleValue];
        
        [self valueChangedInConversionTableForMeasurement:(textField.tag/10) forUnit:(textField.tag % 10) withNewValue:newValue];
        textField.text = finalString;
        
        return NO;
        
    }
    return YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

///-------------------------------------------------
#pragma mark - Measurement Calculations
///-------------------------------------------------

- (void)valueChangedInConversionTableForMeasurement:(PerformanceMeasurement)measurement forUnit:(NSInteger)unitId withNewValue:(double)newValue{
    switch (measurement) {
        case FIRSTROW:
            [self compareValueInUnit:unitId toNewValue:newValue];
            break;
            
        case SECONDROW:
            [self calculateTakeOfTotalRunwayByTempInUnit:unitId toNewValue:newValue];
            break;
            
        case THIRDROW:
            [self calculateTakeOfTotalRunwayInUnit:unitId toNewValue:newValue];
            break;
            
        case FOURTHROW:
            [self calculateLandingTotalRunwayInUnit:unitId toNewValue:newValue];
            break;
            
        case FIFTHROW:
            [self calculateTopRowValueInUnit:unitId toNewValue:newValue row:FIFTHROW];
            //No Functionality has been defined
            break;
            
        case SIXTHROW:
           [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:SIXTHROW];
            break;
            
        case SEVENTHROW:
            //No Functionality has been defined
             [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:SEVENTHROW];
            break;
            
        case EIGHTHROW:
           [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:EIGHTHROW];
            break;
            
        case NINETHROW:
           [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:NINETHROW];
            break;
        case TENTHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:TENTHROW];
            break;
            
        case ELEVENTHROW:
           [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:ELEVENTHROW];
            break;
            
        case TWELVETHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:TWELVETHROW];
            break;
            
        case THIRTEENTHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:THIRTEENTHROW];
            break;
            
        case FOURTEENTHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:FOURTEENTHROW];
            break;
            
        case FIFTEENTHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:FIFTEENTHROW];
            break;
            
        case SIXTEENTHROW:
            [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:SIXTEENTHROW];
            break;
            
        case SEVENTEENTHROW:
             [self calculateFifthRowValueInUnit:unitId toNewValue:newValue row:SEVENTEENTHROW];
            break;
            
        default:
            break;
    }
}




///-------------------------------------------------
#pragma mark - Utility Methods
///-------------------------------------------------
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

-(double)getdecimalTimeFromString:(NSString*)time {
    NSArray *seperateString;
    double hours;
    double minutes;
    double second;
    if ([time containsString:@":"]) {
        seperateString=[time componentsSeparatedByString:@":"];
    }
    if ([seperateString count]==0) {
        hours=[time doubleValue];
    }
    else if ([seperateString count]==1) {
        hours=[seperateString[0] doubleValue];
    }else if ([seperateString count]==2) {
        hours=[seperateString[0] doubleValue];
        minutes=[seperateString[1] doubleValue];
    }else if ([seperateString count]==3) {
        hours=[seperateString[0] doubleValue];
        minutes=[seperateString[1] doubleValue];
        second=[seperateString[2] doubleValue];
    }
    
    minutes=minutes/60;
    
    return hours+minutes+second;
    
}

-(NSString*)convertDecimalTimeTostring:(double)hours {
    
    //    2.88 hours can be broken down to 2 hours plus 0.88 hours - 2 hours
    
    //    0.88 hours * 60 minutes/hour = 52.8 minutes - 52 minutes
    
    //    0.8 minutes * 60 seconds/minute = 48 seconds - 48 seconds
    
    //    02:52:48
    
    float minutes;
    
    int hour=0,minute=0,second;
    
    hour=floor(hours);
    
    minutes=(hours-hour)*60;
    
    minute=floor(minutes);
    
    second=(minutes-minute)*60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    
}

- (double)getRoundedForValue:(double)value uptoDecimal:(int)decimalPlaces{
    int divisor = pow(10, decimalPlaces);
    NSLog(@"%.02f",roundf(value * divisor) / divisor);
    return roundf(value * divisor) / divisor;
}





-(void)compareValueInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *departureRunwayTextField = [self viewWithTag:105];
     switch (unitId) {
        case 5:
             departureRunwayTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
             [self displayeTotal:0 newValue:0];
             break;
     }
}





/** Create Method **/
-(void)calculateTakeOfTotalRunwayByTempInUnit:(NSInteger)unitId toNewValue:(double)newValue {
/** Field Value of TOTAL TAKEOFF RUNWAY **/
    UITextField *lowerColoumTextField = [self viewWithTag:121];
    UITextField *lowerLengthTextField = [self viewWithTag:122];
    UITextField *heigherColoumTextField = [self viewWithTag:123];
    UITextField *heigherLengthTextField = [self viewWithTag:124];
    UITextField *takeOffRunwayTextField = [self viewWithTag:102];
    
/** Field Value of TOTAL LANDING RUNWAY **/
    UITextField *lowerColoumLandingTextField = [self viewWithTag:131];
    UITextField *lowerLengthLandingTextField = [self viewWithTag:132];
    UITextField *heigherColoumLandingTextField = [self viewWithTag:133];
    UITextField *heigherLengthLandingTextField = [self viewWithTag:134];
    UITextField *takeOffRunwayLandingTextField = [self viewWithTag:103];
    
/** Field Value of LANDING Weight **/
    UITextField *atLandingTextField = [self viewWithTag:145];
/** Field Value of LANDING Weight **/
    UITextField *atThisFlightTextField = [self viewWithTag:142];
/** Field Value of Destination Runway **/
    UITextField *destinationRunwayTextField = [self viewWithTag:115];
    float difference;
    switch (unitId) {
        case 1:
            atThisFlightTextField.text = [NSString stringWithFormat:@"%d",(int)newValue];
            [self calculateRowValueInUnit:unitId toNewValue:newValue row:0];
            [self calculateAtThisFlightValueInUnit:0 toNewValue:newValue row:0];
            [self calculateAtLB1ValueInUnit:0 toNewValue:newValue row:0];
            [self calculateAtLB2ValueInUnit:0 toNewValue:newValue row:0];
            break;
        case 2:
            difference = [lowerLengthTextField.text doubleValue] +((([heigherLengthTextField.text doubleValue] - [lowerLengthTextField.text doubleValue])/([heigherColoumTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]))*(newValue - [lowerColoumTextField.text doubleValue]));
            takeOffRunwayTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:difference uptoDecimal:2]];
            break;
        case 3:
            atLandingTextField.text = [NSString stringWithFormat:@"%d",(int)newValue];
             [self calculateRowValueInUnit:unitId toNewValue:newValue row:0];
            [self calculateAtLandingValueInUnit:0 toNewValue:newValue row:0];
            [self calculateAtLB1ValueInUnit:0 toNewValue:newValue row:0];
            [self calculateAtLB2ValueInUnit:0 toNewValue:newValue row:0];
            break;
        case 4:
            difference = [lowerLengthLandingTextField.text doubleValue] +((([heigherLengthLandingTextField.text doubleValue] - [lowerLengthLandingTextField.text doubleValue])/([heigherColoumLandingTextField.text doubleValue] - [lowerColoumLandingTextField.text doubleValue]))*(newValue - [lowerColoumLandingTextField.text doubleValue]));
            takeOffRunwayLandingTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:difference uptoDecimal:2]];
            break;
        case 5:
            destinationRunwayTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:newValue uptoDecimal:2]];
            [self displayeTotal:0 newValue:0];
        default:
            
            break;
    }
    [self displayeTotal:0 newValue:0];
}


-(void)calculateTakeOfTotalRunwayInUnit:(NSInteger)unitId toNewValue:(double)newValue {
        UITextField *lowerColoumTextField = [self viewWithTag:121];
        UITextField *lowerLengthTextField = [self viewWithTag:122];
        UITextField *heigherColoumTextField = [self viewWithTag:123];
        UITextField *heigherLengthTextField = [self viewWithTag:124];
        UITextField *takeOffTempTextField = [self viewWithTag:112];
        UITextField *takeOffRunwayTextField = [self viewWithTag:102];
        float difference;
    switch (unitId) {
        case 1:
            difference = [lowerLengthTextField.text doubleValue] +((([heigherLengthTextField.text doubleValue] - [lowerLengthTextField.text doubleValue])/([heigherColoumTextField.text doubleValue] - newValue))*([takeOffTempTextField.text doubleValue] - newValue));
            break;
        case 2:
            difference = newValue +((([heigherLengthTextField.text doubleValue] - newValue)/([heigherColoumTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
        case 3:
            difference = [lowerLengthTextField.text doubleValue] +((([heigherLengthTextField.text doubleValue] - [lowerLengthTextField.text doubleValue])/(newValue - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
        case 4:
           difference = [lowerLengthTextField.text doubleValue] +(((newValue - [lowerLengthTextField.text doubleValue])/([heigherColoumTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
                default:
            
            break;
    }
    takeOffRunwayTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:difference uptoDecimal:2]];
    [self displayeTotal:0 newValue:0];
}

-(void)calculateLandingTotalRunwayInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *lowerColoumTextField = [self viewWithTag:131];
    UITextField *lowerLengthTextField = [self viewWithTag:132];
    UITextField *heigherColoumTextField = [self viewWithTag:133];
    UITextField *heigherLengthTextField = [self viewWithTag:134];
    UITextField *takeOffTempTextField = [self viewWithTag:114];
    UITextField *takeOffRunwayTextField = [self viewWithTag:103];
    float difference;
    switch (unitId) {
        case 1:
            difference = [lowerLengthTextField.text doubleValue] +((([heigherLengthTextField.text doubleValue] - [lowerLengthTextField.text doubleValue])/([heigherColoumTextField.text doubleValue] - newValue))*([takeOffTempTextField.text doubleValue] - newValue));
            break;
        case 2:
            difference = newValue +((([heigherLengthTextField.text doubleValue] - newValue)/([heigherColoumTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
        case 3:
            difference = [lowerLengthTextField.text doubleValue] +((([heigherLengthTextField.text doubleValue] - [lowerLengthTextField.text doubleValue])/(newValue - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
        case 4:
            difference = [lowerLengthTextField.text doubleValue] +(((newValue - [lowerLengthTextField.text doubleValue])/([heigherColoumTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]))*([takeOffTempTextField.text doubleValue] - [lowerColoumTextField.text doubleValue]));
            break;
        default:
            
            break;
    }
    takeOffRunwayTextField.text=[NSString stringWithFormat:@"%.02f",[self getRoundedForValue:difference uptoDecimal:2]];
    [self displayeTotal:0 newValue:0];
}
-(void)calculateTakeOfInterPolationInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    
   
}



#pragma mark Fifth Row Calculation
-(void)calculateRowValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightTextField = [self viewWithTag:142];
    UITextField *emptyFuelWeightTextField = [self viewWithTag:145];
    UITextField *atLB1TextField = [self viewWithTag:143];
    UITextField *atLB2TextField = [self viewWithTag:144];
    
    float difference,otherDifference;
    switch (unitId) {
        case 1:
            difference = newValue - ((newValue-[emptyFuelWeightTextField.text doubleValue])/3);
            otherDifference = newValue - ((newValue-[emptyFuelWeightTextField.text doubleValue])/3)*2;
            atLB1TextField.text = [NSString stringWithFormat:@"%d",(int)difference];
            atLB2TextField.text = [NSString stringWithFormat:@"%d",(int)otherDifference];
            //[self calculateReverseValueInUnit:0 toNewValue:newValue row:rowIndex];
            break;
        case 3:
            difference = [grossWeightTextField.text doubleValue] - (([grossWeightTextField.text doubleValue]-newValue)/3);
            otherDifference = [grossWeightTextField.text doubleValue] - (([grossWeightTextField.text doubleValue]-newValue)/3)*2;
            atLB1TextField.text = [NSString stringWithFormat:@"%d",(int)difference];
            atLB2TextField.text = [NSString stringWithFormat:@"%d",(int)otherDifference];
            //[self calculateEmptyFuelWaitValueInUnit:0 toNewValue:newValue row:0];
            break;
    }
}

-(void)calculateTopRowValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    switch (unitId) {
        case 1:
            [self calculateReverseValueInUnit:0 toNewValue:newValue row:rowIndex];
            break;
        case 6:
            [self calculateEmptyFuelWaitValueInUnit:0 toNewValue:newValue row:0];
            break;
    }
}

-(void)calculateFifthRowValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    UITextField *atThisFlightUpTextField = [self viewWithTag:142];
    UITextField *atLB1UpTextField = [self viewWithTag:143];
    UITextField *atLB2UpTextField = [self viewWithTag:144];
    UITextField *atLandingUpTextField = [self viewWithTag:145];
    UITextField *emptyFuelWeightUpTextField = [self viewWithTag:146];
    
    
    //UITextField *grossWeightTextField = [self viewWithTag:91+((rowIndex-9)*10)];
    UITextField *atThisFlightTextField = [self viewWithTag:92+((rowIndex-9)*10)];
    UITextField *atLB1TextField = [self viewWithTag:93+((rowIndex-9)*10)];
    UITextField *atLB2TextField = [self viewWithTag:94+((rowIndex-9)*10)];
    UITextField *atLandingTextField = [self viewWithTag:95+((rowIndex-9)*10)];
    UITextField *emptyFuelWeightTextField = [self viewWithTag:96+((rowIndex-9)*10)];
    

    float differenceAtThisFlight,differenceatLB1,differenceAtLB2,differenceAtLandingTextField,differenceEmptyFuelWeight;
    switch (unitId) {
        case 1:
            
            differenceAtThisFlight = sqrt(([atThisFlightUpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*newValue;
            atThisFlightTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtThisFlight uptoDecimal:2]];
            
            differenceatLB1 = sqrt(([atLB1UpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*newValue;
            atLB1TextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceatLB1 uptoDecimal:2]];
            
            differenceAtLB2 = sqrt(([atLB2UpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*newValue;
            atLB2TextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLB2 uptoDecimal:2]];
            
            differenceAtLandingTextField = sqrt(([atLandingUpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*newValue;
            atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
            
            differenceEmptyFuelWeight = sqrt(([emptyFuelWeightUpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*newValue;
            emptyFuelWeightTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceEmptyFuelWeight uptoDecimal:2]];
            
            if (rowIndex == NINETHROW) {
                UITextField *landingRequiredTextField = [self viewWithTag:104];
                landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
            }
            if (rowIndex == EIGHTHROW) {
                UITextField *TakeOffRequiredTextField = [self viewWithTag:101];
                TakeOffRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtThisFlight uptoDecimal:2]];
            }
            break;
    }
    
}



#pragma marl change color when limit exceed
-(void)displayeTotal:(NSInteger)selectedTag newValue:(double)newValue {
    UITextField *takeOffRunwayTextField = [self viewWithTag:102];
    UITextField *departureRunwayTextField = [self viewWithTag:105];
    if ([takeOffRunwayTextField.text doubleValue] < [departureRunwayTextField.text doubleValue] || ([takeOffRunwayTextField.text doubleValue] == 0 && [departureRunwayTextField.text doubleValue] == 0)) {
        takeOffRunwayTextField.layer.borderColor=[UIColor blueColor].CGColor;
        
    }else
    {
        takeOffRunwayTextField.layer.borderColor = [[UIColor redColor] CGColor];
        takeOffRunwayTextField.layer.borderWidth = 1.0f;
        takeOffRunwayTextField.layer.cornerRadius = 5;
    }
    
    UITextField *takeOffLandingTextField = [self viewWithTag:103];
    UITextField *departureLandingTextField = [self viewWithTag:115];
    if ([takeOffLandingTextField.text doubleValue] < [departureLandingTextField.text doubleValue] || ([takeOffLandingTextField.text doubleValue] == 0 && [departureLandingTextField.text doubleValue] == 0)) {
        takeOffLandingTextField.layer.borderColor=[UIColor blueColor].CGColor;
        
    }else
    {
        takeOffLandingTextField.layer.borderColor=[UIColor redColor].CGColor;
        takeOffLandingTextField.layer.borderWidth = 1.0f;
        takeOffLandingTextField.layer.cornerRadius = 5;
    }
}




/***** Reverse Programming ****/
-(void)calculateAtLandingValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    for (int i = 0; i < 12; i++) {
        UITextField *grossWeightTextField = [self viewWithTag:91+(6+i)*10];
        UITextField *atLandingTextField = [self viewWithTag:95+((6+i)*10)];
        
        float differenceAtLandingTextField;
        
        differenceAtLandingTextField = sqrt((newValue/[grossWeightUpTextField.text doubleValue]))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
        atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
        if (rowIndex == NINETHROW && differenceAtLandingTextField > 0) {
            UITextField *landingRequiredTextField = [self viewWithTag:104];
            landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    }
}
-(void)calculateAtThisFlightValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    for (int i = 0; i < 12; i++) {
        UITextField *grossWeightTextField = [self viewWithTag:91+(6+i)*10];
        UITextField *atLandingTextField = [self viewWithTag:92+((6+i)*10)];
        
        float differenceAtLandingTextField;
        
        differenceAtLandingTextField = sqrt((newValue/[grossWeightUpTextField.text doubleValue]))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
        atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
        
        if (rowIndex == EIGHTHROW && differenceAtLandingTextField >0) {
            UITextField *landingRequiredTextField = [self viewWithTag:101];
            landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    }
}



-(void)calculateAtLB1ValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    UITextField *atLB1UpTextField = [self viewWithTag:143];
    for (int i = 0; i < 12; i++) {
        UITextField *grossWeightTextField = [self viewWithTag:91+(6+i)*10];
        UITextField *atLandingTextField = [self viewWithTag:93+((6+i)*10)];
        
        float differenceAtLandingTextField;
        
        differenceAtLandingTextField = sqrt(([atLB1UpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
            atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
        
        if (rowIndex == EIGHTHROW && differenceAtLandingTextField >0) {
            UITextField *landingRequiredTextField = [self viewWithTag:101];
            landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    }
}
-(void)calculateAtLB2ValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    UITextField *atLB2UpTextField = [self viewWithTag:144];
    for (int i = 0; i < 12; i++) {
        UITextField *grossWeightTextField = [self viewWithTag:91+(6+i)*10];
        UITextField *atLandingTextField = [self viewWithTag:94+((6+i)*10)];
        
        float differenceAtLandingTextField;
        
        differenceAtLandingTextField = sqrt(([atLB2UpTextField.text doubleValue]/[grossWeightUpTextField.text doubleValue]))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
            atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
        
        if (rowIndex == EIGHTHROW && differenceAtLandingTextField >0) {
            UITextField *landingRequiredTextField = [self viewWithTag:101];
            landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    }
}

-(void)calculateEmptyFuelWaitValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *grossWeightUpTextField = [self viewWithTag:141];
    for (int i = 0; i < 12; i++) {
        UITextField *grossWeightTextField = [self viewWithTag:91+(6+i)*10];
        UITextField *atLandingTextField = [self viewWithTag:96+((6+i)*10)];
        
        float differenceAtLandingTextField;
        
        differenceAtLandingTextField = sqrt((newValue/[grossWeightUpTextField.text doubleValue]))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
        atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    }
}

-(void)calculateReverseValueInUnit:(NSInteger)unitId toNewValue:(double)newValue row:(PerformanceMeasurement)rowIndex {
    
    UITextField *atThisFlightUpTextField = [self viewWithTag:142];
    UITextField *atLB1UpTextField = [self viewWithTag:143];
    UITextField *atLB2UpTextField = [self viewWithTag:144];
    UITextField *atLandingUpTextField = [self viewWithTag:145];
    UITextField *emptyFuelWeightUpTextField = [self viewWithTag:146];
    
    for (int i = 0; i < 12; i++) {
    UITextField *grossWeightTextField = [self viewWithTag:91+((6+i)*10)];
    UITextField *atThisFlightTextField = [self viewWithTag:92+((6+i)*10)];
    UITextField *atLB1TextField = [self viewWithTag:93+((6+i)*10)];
    UITextField *atLB2TextField = [self viewWithTag:94+((6+i)*10)];
    UITextField *atLandingTextField = [self viewWithTag:95+((6+i)*10)];
    UITextField *emptyFuelWeightTextField = [self viewWithTag:96+((6+i)*10)];
    
    
    float differenceAtThisFlight,differenceatLB1,differenceAtLB2,differenceAtLandingTextField,differenceEmptyFuelWeight;
    
    differenceAtThisFlight = sqrt(([atThisFlightUpTextField.text doubleValue]/newValue))*[grossWeightTextField.text doubleValue];
    if (differenceAtThisFlight > 0) {
        atThisFlightTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtThisFlight uptoDecimal:2]];

    }
        
    differenceatLB1 = sqrt(([atLB1UpTextField.text doubleValue]/newValue))*[grossWeightTextField.text doubleValue];
        if (differenceatLB1 > 0) {
    atLB1TextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceatLB1 uptoDecimal:2]];
        }
    
    differenceAtLB2 = sqrt(([atLB2UpTextField.text doubleValue]/newValue))*[grossWeightTextField.text doubleValue];
        if (differenceAtLB2 > 0) {
    atLB2TextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLB2 uptoDecimal:2]];
        }
    
    differenceAtLandingTextField = sqrt(([atLandingUpTextField.text doubleValue]/newValue))*[grossWeightTextField.text doubleValue];
        if (differenceAtLandingTextField > 0) {
    atLandingTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
        }
    
    
    differenceEmptyFuelWeight = sqrt(([emptyFuelWeightUpTextField.text doubleValue]/newValue))*[grossWeightTextField.text doubleValue];
         if (differenceEmptyFuelWeight > 0) {
    emptyFuelWeightTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceEmptyFuelWeight uptoDecimal:2]];
         }
    
    
    if (rowIndex == 4 && differenceAtLandingTextField > 0) {
        UITextField *landingRequiredTextField = [self viewWithTag:104];
        landingRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtLandingTextField uptoDecimal:2]];
    }
    if (rowIndex == 3 && differenceAtThisFlight > 0) {
        UITextField *TakeOffRequiredTextField = [self viewWithTag:101];
        TakeOffRequiredTextField.text = [NSString stringWithFormat:@"%.02f",[self getRoundedForValue:differenceAtThisFlight uptoDecimal:2]];
    }
    }
}
@end

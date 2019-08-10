//
//  CalculationsCell.m
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import "ConversionsCell.h"

#define ACCEPTABLE_CHARECTERS @"0123456789."
#define ACCEPTABLE_TIMECHARECTERS @"0123456789:"
#define ACCEPTABLE_TEMPCHARACTERS @"0123456789.-"

@interface ConversionsCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

typedef enum : NSUInteger {
    TEMPs = 10,
    DISTANCE,
    WEIGHTS,
    FLUIDS,
    SPEED,
    FUEL,
    TIME,
    TIMEZONE,
    ADMOSPRESSURE
} ConversionMeasurement;

@implementation ConversionsCell
int isValue = 0;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.containerView.layer.borderWidth = 1.0;
    
    for (UIView *subView in self.containerView.subviews) {
        if (subView.subviews.count == 0){
            continue;
        }
        for (UIView *aView in subView.subviews) {
            if ([aView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)aView;
                if ([[NSUserDefaults standardUserDefaults ] boolForKey:@"SavedText"]==YES) {
                    textField.text=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",(long)textField.tag+1000]];
                }
                
//                UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
//                numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//                numberToolbar.items = [NSArray arrayWithObjects:
//                                       [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
//                                       nil];
//                [numberToolbar sizeToFit];
//                textField.inputAccessoryView = numberToolbar;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.delegate = self;
                textField.textColor = [UIColor blueColor];
                [textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
                //                textField.placeholder = @"0.00";
            }
            if ([aView isKindOfClass:[UIButton class]]) {
                // Adding rounded corner to button
                UIButton *button = (UIButton *)aView;
                if (button.tag!=1000 && button.tag!=1001 && button.tag!=1002) {
                    button.layer.cornerRadius = 10;
                    button.layer.borderWidth = 1;
                }
                                button.layer.borderColor = [UIColor blueColor].CGColor;
                                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                button.layer.borderColor = [UIColor colorWithRed:0/255.0 green:222/255.0 blue:255/255.0 alpha:1.0].CGColor;
//                [button setTitleColor:[UIColor colorWithRed:0/255.0 green:222/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearText:) name:@"ClearText" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveText:) name:@"SaveText" object:nil];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)clearText:(NSNotification *) notification {
    
    for (UIView *subView in self.containerView.subviews) {
        if (subView.subviews.count == 0){
            continue;
        }
        
        for (UIView *aView in subView.subviews) {
            if ([aView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)aView;
                textField.text=@"";
            }
        }
    }
}
-(void)saveText:(NSNotification *) notification {
    
    for (UIView *subView in self.containerView.subviews) {
        if (subView.subviews.count == 0){
            continue;
        }
        
        for (UITextField *textField in subView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
               
                [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:[NSString stringWithFormat:@"%ld",(long)textField.tag+1000]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SavedText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///-------------------------------------------------
#pragma mark - ActionMethods
///-------------------------------------------------

- (IBAction)clearTemperature:(id)sender {
    ((UITextField *)[self viewWithTag:101]).text = @"";
    ((UITextField *)[self viewWithTag:102]).text = @"";
    ((UITextField *)[self viewWithTag:103]).text = @"";
}

- (IBAction)clearDistance:(id)sender {
    ((UITextField *)[self viewWithTag:111]).text = @"";
    ((UITextField *)[self viewWithTag:112]).text = @"";
    ((UITextField *)[self viewWithTag:113]).text = @"";
    ((UITextField *)[self viewWithTag:114]).text = @"";
}

- (IBAction)clearWeights:(id)sender {
    ((UITextField *)[self viewWithTag:121]).text = @"";
    ((UITextField *)[self viewWithTag:122]).text = @"";
    ((UITextField *)[self viewWithTag:123]).text = @"";
}

- (IBAction)clearFluids:(id)sender {
    ((UITextField *)[self viewWithTag:131]).text = @"";
    ((UITextField *)[self viewWithTag:132]).text = @"";
    ((UITextField *)[self viewWithTag:133]).text = @"";
    ((UITextField *)[self viewWithTag:134]).text = @"";
    ((UITextField *)[self viewWithTag:135]).text = @"";
}

- (IBAction)clearSpeed:(id)sender {
    ((UITextField *)[self viewWithTag:141]).text = @"";
    ((UITextField *)[self viewWithTag:142]).text = @"";
    ((UITextField *)[self viewWithTag:143]).text = @"";
}
- (IBAction)clearFuel:(id)sender {
    ((UITextField *)[self viewWithTag:151]).text = @"";
    ((UITextField *)[self viewWithTag:152]).text = @"";
    ((UITextField *)[self viewWithTag:153]).text = @"";
    ((UITextField *)[self viewWithTag:154]).text = @"";
    ((UITextField *)[self viewWithTag:155]).text = @"";
    ((UITextField *)[self viewWithTag:156]).text = @"";
}
- (IBAction)clearTime:(id)sender {
    ((UITextField *)[self viewWithTag:161]).text = @"";
    ((UITextField *)[self viewWithTag:162]).text = @"";
    ((UITextField *)[self viewWithTag:163]).text = @"";
    ((UITextField *)[self viewWithTag:164]).text = @"";
}
- (IBAction)clearTimeZone:(id)sender {
    ((UITextField *)[self viewWithTag:171]).text = @"";
    ((UITextField *)[self viewWithTag:172]).text = @"";
    ((UITextField *)[self viewWithTag:173]).text = @"";
}
- (IBAction)clearAdmosPressure:(id)sender {
    ((UITextField *)[self viewWithTag:181]).text = @"";
    ((UITextField *)[self viewWithTag:182]).text = @"";
    ((UITextField *)[self viewWithTag:183]).text = @"";
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
    
    NSString *acceptableCharacter=ACCEPTABLE_CHARECTERS;
    if (textField.tag==161 || textField.tag==162 || textField.tag==163 || textField.tag==171 || textField.tag==172 || textField.tag==173) {
        acceptableCharacter=ACCEPTABLE_TIMECHARECTERS;
    }else if (textField.tag==101 || textField.tag==102 || textField.tag==103) {
        acceptableCharacter=ACCEPTABLE_TEMPCHARACTERS;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacter] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:[string isEqualToString:filtered]?string:@""];
    if ([acceptableCharacter isEqual:ACCEPTABLE_TEMPCHARACTERS]) {
        if (([string isEqualToString:@"."] || [string isEqualToString:@"-"] ) && range.length<1 ) {
            if ([string isEqualToString:@"."] && [textField.text containsString:@"."]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }else if ([string isEqualToString:@"-"] && [textField.text containsString:@"-"]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }
           
        }
    }
   else if (textField.tag==181 ) {
        if ([finalString length]==2 && ![finalString containsString:@"."] && range.length<1) {
            finalString=[NSString stringWithFormat:@"%@.",finalString];

        }else if ([string isEqualToString:@"."] && range.length<1 ) {
            NSString *lastCharacter=[finalString substringFromIndex:[finalString length] - 1];
            if ([lastCharacter isEqualToString:string]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }
        }
        else if([finalString length]>5) {
            finalString =[finalString substringToIndex:5];
        }
        
    }else if (textField.tag==161 || textField.tag==162 ||textField.tag==163 || textField.tag==171 || textField.tag==172 || textField.tag==173) {
        if (([finalString length]==2|| [finalString length]==5)  && range.length<1) {
            if (![string isEqualToString:@":"]) {
                finalString=[NSString stringWithFormat:@"%@:",finalString];
                
            }
        }else if ([string isEqualToString:@":"] && range.length<1 ) {
            NSString *lastCharacter=[finalString substringFromIndex:[finalString length] - 1];
            if ([lastCharacter isEqualToString:string]) {
                finalString=[finalString substringToIndex:[finalString length] - 1];
            }
        }

        else if([finalString length]>8) {
            finalString =[finalString substringToIndex:8];
        }
    }
    double newValue=[finalString doubleValue];
    
    if (textField.tag==161 || textField.tag==162 ||textField.tag==163 || textField.tag==171 || textField.tag==172 || textField.tag==173)
    {
        //            if((isValue == 1) || (isValue == 3))
        //            {
        //                finalString = [finalString stringByAppendingString:@":"];
        //                NSLog(@"%@",finalString);
        //                [textField setText:finalString];
        //                isValue ++;
        //                return NO;
        //            }
        newValue=[self getdecimalTimeFromString:finalString];
    }
    [self valueChangedInConversionTableForMeasurement:(textField.tag/10) forUnit:(textField.tag % 10) withNewValue:newValue];
    textField.text = finalString;
    isValue ++;
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

///-------------------------------------------------
#pragma mark - Measurement Calculations
///-------------------------------------------------

- (void)valueChangedInConversionTableForMeasurement:(ConversionMeasurement)measurement forUnit:(NSInteger)unitId withNewValue:(double)newValue{
    switch (measurement) {
        case TEMPs:
            [self calculateTemperatureConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
            
        case DISTANCE:
            [self calculateDistanceConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
            
        case WEIGHTS:
            [self calculateWightsConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
            
        case FLUIDS:
            [self calculateFluidsConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
            
        case SPEED:
            [self calculateSpeedConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
        case FUEL:
            [self calculateFuelConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
        case TIME:
            [self calculateTimeConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
        case TIMEZONE:
            [self calculateTimeZoneConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
        case ADMOSPRESSURE:
            [self calculateAdmosPressureConversionsOnChangeInUnit:unitId toNewValue:newValue];
            break;
        default:
            break;
    }
}

- (void)calculateTemperatureConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue{
    double celsiusVaue = 0.00;
    
    switch (unitId) {
        case 1:// Celsius
            celsiusVaue = newValue;
            break;
            
        case 2:// Fahrenheit// celsius = (fahrenheit - 32.0) * (5.0 / 9.0)
            celsiusVaue = (newValue - 32.0) * (5.0 / 9.0);
            break;
            
        case 3:// kelvin// celsius = kelvin - 273.15
            celsiusVaue = newValue - 273.15;
            break;
            
        default:
            break;
    }
    
    double fahrenheitValue = celsiusVaue * (9.0/5.0) + 32.0;
    double kelvinValue = celsiusVaue + 273.15;
    
    UITextField *celsiusTextField = [self viewWithTag:101];
    UITextField *fahrenheitTextField = [self viewWithTag:102];
    UITextField *kelvinTextField = [self viewWithTag:103];
    
    celsiusTextField.text = [NSString stringWithFormat:@"%.02f", roundf(celsiusVaue)];
    fahrenheitTextField.text = [NSString stringWithFormat:@"%.02f", roundf(fahrenheitValue)];
    kelvinTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:kelvinValue uptoDecimal:2]];
}

- (void)calculateDistanceConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue{
    double milesValue = 0.00;
    
    switch (unitId) {
        case 1:// Miles(SM)
            milesValue = newValue;
            break;
            
        case 2:// Feet(FT)// mile = feet / 5280.0
            milesValue = newValue / 5280.0;
            break;
            
        case 3:// Nutical Miles(NM)// mile = nautical_miles * 1.15078
            milesValue = newValue * 1.15078;
            break;
            
        case 4:// Kilometers(KM)// mile = kilometers * 0.62137
            milesValue = newValue * 0.62137;
            break;
            
        default:
            break;
    }
    
    double feetValue = milesValue * 5280.0;                 // feet = mile * 5280.0;
    double nauticalMilesValue = milesValue / 1.15078;       // nautical_mile = mile / 1.15078
    double kilometersValue = milesValue / 0.62137;          // kilometers = mile / 0.62137
    
    UITextField *milesTextField = [self viewWithTag:111];
    UITextField *feetTextField = [self viewWithTag:112];
    UITextField *nauticalMilesTextField = [self viewWithTag:113];
    UITextField *kilometersTextField = [self viewWithTag:114];
    
    //milesTextField.text = [NSString stringWithFormat:@"%.02f", roundf(milesValue)];
    //feetTextField.text = [NSString stringWithFormat:@"%.02f", roundf(feetValue)];
    milesTextField.text = [NSString stringWithFormat:@"%.02f",milesValue];
    feetTextField.text = [NSString stringWithFormat:@"%.02f",feetValue];
    nauticalMilesTextField.text = [NSString stringWithFormat:@"%.5f", [self getRoundedForValue:nauticalMilesValue uptoDecimal:5]];
    kilometersTextField.text = [NSString stringWithFormat:@"%.5f", [self getRoundedForValue:kilometersValue uptoDecimal:5]];
}

- (void)calculateWightsConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue{
    double poundsValue = 0.00;
    
    switch (unitId) {
        case 1:// Pounds(LB)
            poundsValue = newValue;
            break;
            
        case 2:// Kilos(KL)// pound(lb) = kg * 2.2046
            poundsValue = newValue * 2.2046;
            break;
            
        case 3:// Tons(T)// pound(lb) = ton * 2000
            poundsValue = newValue * 2000;
            break;
            
        default:
            break;
    }
    
    
    double kilosValue = poundsValue / 2.2046;   // kilo = pound(lb) / 2.2046
    double tonsValue = poundsValue / 2000;      // ton = pound(lb) / 2000
    
    UITextField *poundsTextField = [self viewWithTag:121];
    UITextField *kilosTextField = [self viewWithTag:122];
    UITextField *tonsTextField = [self viewWithTag:123];
    
    poundsTextField.text = [NSString stringWithFormat:@"%.02f", roundf(poundsValue)];
    kilosTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:kilosValue uptoDecimal:2]];
    tonsTextField.text = [NSString stringWithFormat:@"%.4f", [self getRoundedForValue:tonsValue uptoDecimal:4]];
}

- (void)calculateFluidsConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue{
    double gallonsValue = 0.00;
    
    switch (unitId) {
        case 1:// Gallons(GL)
            gallonsValue = newValue;
            break;
            
        case 2:// Ounces(OZ)// gallon = ounces / 128
            gallonsValue = newValue / 128.0;
            break;
            
        case 3:// Quarts(QT)// gallon = quarts / 4
            gallonsValue = newValue / 4.0;
            break;
            
        case 4:// Pints(PT)// gallon = pint / 8
            gallonsValue = newValue / 8.0;
            break;
            
        case 5:// Litters(LT)// gallon = litter * 0.26417
            gallonsValue = newValue * 0.26417;
            break;
            
        default:
            break;
    }
    
    
    double ouncesValue = gallonsValue * 128;        // ounce = gallon * 128
    double quartsValue = gallonsValue * 4.0;        // quart = gallon * 4
    double pintsValue = gallonsValue * 8.0;         // pint = gallon * 8
    double littersValue = gallonsValue / 0.26417;   // litter = gallon / 0.26417
    
    UITextField *gallonsTextField = [self viewWithTag:131];
    UITextField *ouncesTextField = [self viewWithTag:132];
    UITextField *quartsTextField = [self viewWithTag:133];
    UITextField *pintsTextField = [self viewWithTag:134];
    UITextField *littersTextField = [self viewWithTag:135];
    
    gallonsTextField.text = [NSString stringWithFormat:@"%.02f", roundf(gallonsValue)];
    ouncesTextField.text = [NSString stringWithFormat:@"%.02f", roundf(ouncesValue)];
    quartsTextField.text = [NSString stringWithFormat:@"%.02f", roundf(quartsValue)];
    pintsTextField.text = [NSString stringWithFormat:@"%.02f", roundf(pintsValue)];
    littersTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:littersValue uptoDecimal:2]];
}

- (void)calculateSpeedConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue{
    double knotsValue = 0.00;
    
    switch (unitId) {
        case 1://Knots(KTS)
            knotsValue = newValue;
            break;
            
        case 2://MPH// knot = mph * 0.86897624190816
            knotsValue = newValue * 0.86897624190816;
            break;
            
        case 3://KPH// knot = kph / 1.85200
            knotsValue = newValue / 1.85200;
            break;
            
        default:
            break;
    }
    
    double mphValue = knotsValue / 0.86897624190816;    // mph = knot / 0.86897624190816
    double kphValue = knotsValue * 1.85200;             // kph = knot / 1.85200
    
    UITextField *knotsTextField = [self viewWithTag:141];
    UITextField *mphTextField = [self viewWithTag:142];
    UITextField *kphTextField = [self viewWithTag:143];
    
    knotsTextField.text = [NSString stringWithFormat:@"%.02f", roundf(knotsValue)];
    mphTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:mphValue uptoDecimal:2]];
    kphTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:kphValue uptoDecimal:2]];
}

- (void)calculateFuelConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    
    UITextField *poundTextField = [self viewWithTag:151];
    UITextField *AvVGASTextField = [self viewWithTag:152];
    UITextField *jetTextField = [self viewWithTag:153];
    UITextField *tksTextField = [self viewWithTag:154];
    UITextField *oilTextField = [self viewWithTag:155];
    UITextField *waterTextField = [self viewWithTag:156];
    double poundValue = 0.00;
    switch (unitId) {
        case 1:
            poundValue=newValue;
            break;
        case 2:
            poundValue=newValue*6;
            break;
        case 3:
            poundValue=newValue*6.7;
            break;
        case 4:
            poundValue=newValue*9.12;
            break;
        case 5:
            poundValue=newValue*7.5;
            break;
        case 6:
            poundValue=newValue*8.36;
            break;
            
            
        default:
            break;
    }
    poundTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue uptoDecimal:2]];
    AvVGASTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue/6 uptoDecimal:2]];
    jetTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue/6.7 uptoDecimal:2]];
    tksTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue/9.12 uptoDecimal:2]];
    oilTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue/7.5 uptoDecimal:2]];
    waterTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:poundValue/8.36 uptoDecimal:2]];
}


- (void)calculateTimeConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *startTimeTextField = [self viewWithTag:161];
    UITextField *endTimeTextField = [self viewWithTag:162];
    UITextField *totalTextField = [self viewWithTag:163];
    UITextField *decimalTextField = [self viewWithTag:164];
    double startTime=0.00,endTime=0.00,decimalTime=0.00,totalTime=0.00;

    switch (unitId)
    {
        case 1:
            startTime=newValue;
            endTime=[self getdecimalTimeFromString:endTimeTextField.text];
            if ((startTime == 0 && endTime != 0 && totalTime == 0 && decimalTime == 0) || (startTime != 0 && endTime != 0 && totalTime == 0 && decimalTime == 0))
            {
                decimalTime=endTime-startTime;
                totalTextField.text=[self convertDecimalTimeTostring:decimalTime];
                decimalTextField.text=[NSString stringWithFormat:@"%.02f", [self getRoundedForValue:decimalTime uptoDecimal:2]];
            }
            else if (startTime != 0 && endTime == 0 && totalTime == 0 && decimalTime == 0)
            {
                totalTextField.text=@"";
                decimalTextField.text=@"";
            }
            break;
        case 2:
            startTime=[self getdecimalTimeFromString:startTimeTextField.text];
            endTime=newValue;
            if ((startTime != 0 && endTime == 0 && totalTime == 0) || (startTime != 0 && endTime != 0 && totalTime == 0) || (startTime != 0 && endTime == 0 && totalTime == 0) || (startTime != 0 && endTime != 0 && totalTime == 0))
            {
                decimalTime=endTime-startTime;
                totalTextField.text=[self convertDecimalTimeTostring:decimalTime];
                decimalTextField.text=[NSString stringWithFormat:@"%.02f", [self getRoundedForValue:decimalTime uptoDecimal:2]];
            }
            else if (startTime == 0 && endTime != 0 && totalTime == 0 && decimalTime == 0)
            {
                totalTextField.text=@"";
                decimalTextField.text=@"";
            }
            else
            {
                decimalTime=endTime-startTime;
                totalTextField.text=[self convertDecimalTimeTostring:decimalTime];
                decimalTextField.text=[NSString stringWithFormat:@"%.02f", [self getRoundedForValue:decimalTime uptoDecimal:2]];
            }
            
            break;
        case 3:
            totalTime=newValue;
            endTime=[self getdecimalTimeFromString:endTimeTextField.text];
            startTime=[self getdecimalTimeFromString:startTimeTextField.text];
            
            if ((startTime == 0 && endTime != 0 && totalTime != 0) || (startTime == 0 && endTime != 0 && totalTime == 0) || (startTime == 0 && endTime == 0 && totalTime != 0) || (startTime != 0 && endTime != 0 && totalTime != 0) || (startTime != 0 && endTime != 0 && totalTime == 0))
            {
                endTime = totalTime;
                startTime =  endTime - totalTime;
                endTimeTextField.text = [self convertDecimalTimeTostring:totalTime];
                startTimeTextField.text=[self convertDecimalTimeTostring:startTime];
                decimalTextField.text=[NSString stringWithFormat:@"%.02f", [self getRoundedForValue:decimalTime uptoDecimal:2]];
            }
            else
            {
                endTime = startTime + totalTime;
                endTimeTextField.text=[self convertDecimalTimeTostring:endTime];
                decimalTextField.text=[NSString stringWithFormat:@"%.02f", [self getRoundedForValue:decimalTime uptoDecimal:2]];
            }
            break;
        case 4:
            totalTime=newValue;
            endTime=[self getdecimalTimeFromString:endTimeTextField.text];
            startTime=[self getdecimalTimeFromString:startTimeTextField.text];
            
            if ((startTime == 0 && endTime != 0 && totalTime != 0) || (startTime == 0 && endTime != 0 && totalTime == 0) || (startTime == 0 && endTime == 0 && totalTime != 0) || (startTime != 0 && endTime != 0 && totalTime != 0) || (startTime != 0 && endTime != 0 && totalTime == 0) || (startTime == 0 && endTime == 0 && totalTime != 0) )
            {
                endTime = totalTime;
                startTime =  endTime - totalTime;
                endTimeTextField.text = [self convertDecimalTimeTostring:totalTime];
                startTimeTextField.text=[self convertDecimalTimeTostring:startTime];
                totalTextField.text=[self convertDecimalTimeTostring:totalTime];
            }
            else
            {
                endTime = startTime + totalTime;
                endTimeTextField.text=[self convertDecimalTimeTostring:endTime];
                totalTextField.text=[self convertDecimalTimeTostring:totalTime];
            }
            break;
        default:
            break;
    }
}

- (void)calculateTimeZoneConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    
    UITextField *localTimeTextField = [self viewWithTag:171];
    UITextField *gmtTimeTextField = [self viewWithTag:172];
    UITextField *customTimeTextField = [self viewWithTag:173];
    NSString *localTime=@"00:00:00",*gmtTime=@"00:00:00",*customTime=@"00:00:00";
    
    switch (unitId) {
        case 1:
            if (newValue>0) {
                localTime=[self convertDecimalTimeTostring:newValue];
                gmtTime=[self getGMTTimeFromLocal:localTime];
                customTime=[self getCustomTimeFromLocal:localTime];
            }
            
            break;
        case 2:
            if (newValue>0) {
                localTime=[self getLocalTimeFromGMT:[self convertDecimalTimeTostring:newValue]];
                gmtTime=[self convertDecimalTimeTostring:newValue];
                customTime=[self getCustomTimeFromLocal:localTime];
            }
            break;
        case 3:
            if (newValue>0) {
                localTime=[self getLocalTimeFromCustom:[self convertDecimalTimeTostring:newValue]];
                gmtTime=[self getGMTTimeFromLocal:localTime];
                customTime=[self convertDecimalTimeTostring:newValue];
            }
            break;
            
        default:
            break;
    }
    localTimeTextField.text=localTime;
    gmtTimeTextField.text=gmtTime;
    customTimeTextField.text=customTime;
}
- (void)calculateAdmosPressureConversionsOnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *beroTextField = [self viewWithTag:181];
    UITextField *millibarsTextField = [self viewWithTag:182];
    UITextField *psiTextField = [self viewWithTag:183];
    double mbarValue;
    switch (unitId) {
        case 1:
            mbarValue=newValue*33.8638816;
            break;
        case 2:
            mbarValue=newValue;
            break;
        case 3:
            mbarValue=newValue/68.9475728;
            break;
            
        default:
            break;
    }
    beroTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:mbarValue/33.8638816 uptoDecimal:2]];
    millibarsTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:mbarValue uptoDecimal:2]];
    psiTextField.text = [NSString stringWithFormat:@"%.02f", [self getRoundedForValue:mbarValue/68.9475728 uptoDecimal:2]];
}
- (IBAction)actionLocal:(id)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    UITextField *localTimeTextField = [self viewWithTag:171];
    UITextField *gmtTimeTextField = [self viewWithTag:172];
    UITextField *customTimeTextField = [self viewWithTag:173];
    
    localTimeTextField.text=[dateFormatter stringFromDate:[NSDate date]];
    
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    gmtTimeTextField.text=[dateFormatter stringFromDate:[NSDate date]];
    
    UIButton *btn=(UIButton*)[self.containerView viewWithTag:1002];
    NSString *abbreviation=[[[[[btn currentTitle] componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:abbreviation]];
    customTimeTextField.text=[dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"zzz"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *abbrevation= [[[[[dateFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@"+"] objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0];
    [sender setTitle:[NSString stringWithFormat:@"LOCAL(%@)",abbrevation] forState:UIControlStateNormal];
    
}
- (IBAction)actionZuhu:(id)sender {
    
    
}
- (IBAction)actionCustom:(id)sender {
    dictTimeZone = [NSTimeZone abbreviationDictionary];
    
    
    
    //Create the view controller you want to display.
    UIViewController* popoverContent = [[UIViewController alloc] init]; //ViewController
    
    UIView *popoverView = [[UIView alloc] init];   //view
    popoverView.backgroundColor = [UIColor clearColor];
    
    UIPickerView *objPickerView = [[UIPickerView alloc]init];//Date picker
    objPickerView.delegate = self; // Also, can be done from IB, if you're using
    objPickerView.dataSource = self;// Also, can be done from IB, if you're using
    objPickerView.frame=CGRectMake(0,44,320, 216);
    [popoverView addSubview:objPickerView];
    popoverContent.view = popoverView;
    
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    popoverController.delegate = self;
    
    [popoverController setPopoverContentSize:CGSizeMake(320, 264) animated:NO];
    [popoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;//Or return whatever as you intend
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [dictTimeZone allKeys].count;//Or, return as suitable for you...normally we use array for dynamic
}
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSString stringWithFormat:@"%@(%@)",[[[dictTimeZone valueForKey:[[dictTimeZone allKeys] objectAtIndex:row]] componentsSeparatedByString:@"/"] objectAtIndex:0],[[dictTimeZone allKeys] objectAtIndex:row]] uppercaseString];//[NSString stringWithFormat:@"Choice-%ld",(long)row];//Or, your suitable title; like Choice-a, etc.
}
- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIButton *btn=(UIButton*)[self.containerView viewWithTag:1002];
    NSString *abbreviation=[[[[[btn currentTitle] componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
    NSString *title=[NSString stringWithFormat:@"%@(%@)",[[[dictTimeZone valueForKey:[[dictTimeZone allKeys] objectAtIndex:row]] componentsSeparatedByString:@"/"] objectAtIndex:0],[[dictTimeZone allKeys] objectAtIndex:row]];
    [btn setTitle:[title uppercaseString] forState:UIControlStateNormal];
    
    UITextField *customTimeTextField = [self viewWithTag:173];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:abbreviation]];
    NSDate *date=[dateFormatter dateFromString:customTimeTextField.text];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:[[dictTimeZone allKeys] objectAtIndex:row]]];
    customTimeTextField.text= [dateFormatter stringFromDate:date];
}
///-------------------------------------------------
#pragma mark - Utility Methods
///-------------------------------------------------

-(NSString*)getGMTTimeFromLocal:(NSString*)time {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date=[dateFormatter dateFromString:time];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    return [dateFormatter stringFromDate:date];
}
-(NSString*)getLocalTimeFromGMT:(NSString*)time {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date=[dateFormatter dateFromString:time];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return [dateFormatter stringFromDate:date];
}
-(NSString*)getLocalTimeFromCustom:(NSString*)time {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    UIButton *btn=(UIButton*)[self.containerView viewWithTag:1002];
    NSString *abbreviation=[[[[[btn currentTitle] componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:abbreviation]];
    NSDate *date=[dateFormatter dateFromString:time];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    return [dateFormatter stringFromDate:date];
    
}
-(NSString*)getCustomTimeFromLocal:(NSString*)time {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date=[dateFormatter dateFromString:time];
    UIButton *btn=(UIButton*)[self.containerView viewWithTag:1002];
    NSString *abbreviation=[[[[[btn currentTitle] componentsSeparatedByString:@"("] objectAtIndex:1] componentsSeparatedByString:@")"] objectAtIndex:0];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:abbreviation]];
    
    return [dateFormatter stringFromDate:date];
    
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
    
    return roundf(value * divisor) / divisor;
}

@end

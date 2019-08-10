//
//  FlightPlanningCell.m
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import "FlightPlanningCell.h"
#import "FlightPlanning.h"
#import "CustomCell.h"
#import "CSIP-Swift.h"

#define ENTITY_FLIGHTPLANNING @"FlightPlanning"

#define ACCEPTABLE_CHARECTERS @"0123456789."
#define ACCEPTABLE_TIMECHARECTERS @"0123456789:"

@interface FlightPlanningCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

typedef enum : NSUInteger {
    LEG1 = 10,
    LEG2,
    LEG3,
    LEG4,
    FUELLOAD
  
    
} CalculationsMeasurement;

@implementation FlightPlanningCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.arrayFiles=[[NSMutableArray alloc] init];
    
    
    
//    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
//    self.containerView.layer.borderWidth = 1.0;
    
    for (UIView *aView in self.containerView.subviews) {

       // for (UIView *aView in subView.subviews) {
            if ([aView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)aView;
                
//                UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50)];
//                numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//                numberToolbar.items = [NSArray arrayWithObjects:
//                                       [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
//                                       nil];
//                [numberToolbar sizeToFit];
//                textField.inputAccessoryView = numberToolbar;
                if (textField.isUserInteractionEnabled) {
                    textField.textColor=[UIColor blueColor];
                    [textField setValue:[UIColor blueColor] forKeyPath:@"_placeholderLabel.textColor"];
                }else
                    textField.textColor=[UIColor blackColor];
                
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.delegate = self;
                //                textField.placeholder = @"0.00";
            }
            
            if ([aView isKindOfClass:[UIButton class]]) {
                // Adding rounded corner to button
                UIButton *button = (UIButton *)aView;
                
                button.layer.cornerRadius = 10;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor blueColor].CGColor;
                [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                button.layer.borderColor = [UIColor colorWithRed:0/255.0 green:222/255.0 blue:255/255.0 alpha:1.0].CGColor;
//                [button setTitleColor:[UIColor colorWithRed:0/255.0 green:222/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
   // }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearText) name:@"ClearText" object:nil];
    self.saveFlightBtn.layer.cornerRadius = 5.0;
    self.saveFlightBtn.layer.borderWidth = 1.0;
    self.saveFlightBtn.layer.borderColor = self.saveFlightBtn.titleLabel.textColor.CGColor;

    [self getSavedFiles];

    self.saveTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)clearText {
    for (UIView *aView in self.containerView.subviews) {
//        if (subView.subviews.count == 0){
//            continue;
//        }
        
//        for (UIView *aView in subView.subviews) {
            if ([aView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)aView;
                textField.text=@"";
                
            }
        }
   // }
}
///-------------------------------------------------
#pragma mark - ActionMethods
///-------------------------------------------------
-(BOOL)exist
{
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext=[appDelegate getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:ENTITY_FLIGHTPLANNING inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setFetchLimit:1];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@", self.nameTxtField.text]];
    
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

- (IBAction)saveAction:(id)sender {
    if ([self.nameTxtField.text length]>0) {
        if (![self exist]) {
        AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        NSManagedObjectContext *context=[appDelegate getContext];
        NSEntityDescription *descriptor=[NSEntityDescription entityForName:ENTITY_FLIGHTPLANNING inManagedObjectContext:context];
        FlightPlanning *planning=[[FlightPlanning alloc] initWithEntity:descriptor insertIntoManagedObjectContext:context];
        planning.name=self.nameTxtField.text;
        
        planning.dist1=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:101]).text doubleValue]];
        planning.gs1=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:102]).text doubleValue]];
        planning.time1=((UITextField *)[self viewWithTag:103]).text ;
        planning.distRem1=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:104]).text doubleValue]];
        planning.galUsed1=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:105]).text doubleValue]];
        planning.galRem1=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:106]).text doubleValue]];
        
        planning.dist2=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:111]).text doubleValue]];
        planning.gs2=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:112]).text doubleValue]];
        planning.time2=((UITextField *)[self viewWithTag:113]).text ;
        planning.distRem2=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:114]).text doubleValue]];
        planning.galUsed2=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:115]).text doubleValue]];
        planning.galRem2=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:116]).text doubleValue]];
        
        planning.dist3=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:121]).text doubleValue]];
        planning.gs3=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:122]).text doubleValue]];
        planning.time3=((UITextField *)[self viewWithTag:123]).text ;
        planning.distRem3=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:124]).text doubleValue]];
        planning.galUsed3=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:125]).text doubleValue]];
        planning.galRem3=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:126]).text doubleValue]];
        
        planning.dist4=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:131]).text doubleValue]];
        planning.gs4=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:132]).text doubleValue]];
        planning.time4=((UITextField *)[self viewWithTag:133]).text ;
        planning.distRem4=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:134]).text doubleValue]];
        planning.galUsed4=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:135]).text doubleValue]];
        planning.galRem4=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:136]).text doubleValue]];
        
        planning.fuelLoad=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:141]).text doubleValue]];
        planning.galHR=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:142]).text doubleValue]];
        planning.totalDist=[NSNumber numberWithDouble:[((UITextField *)[self viewWithTag:143]).text doubleValue]];
        
        NSError *error;
        [context save:&error];
        if (!error) {
            [self.arrayFiles addObject:planning];
            self.nameTxtField.text=@"";
        }
        [self.saveTableView reloadData];
        }else {
            [self displayAlertWithMessage:@"File name already exist."];
        }
    }
}
- (IBAction)clearAction:(id)sender {
    [self clearText];
}
-(void)displayDetails:(FlightPlanning*)planning {
    ((UITextField *)[self viewWithTag:101]).text=[planning.dist1 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.dist1 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:102]).text=[planning.gs1 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.gs1 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:103]).text=[planning.time1 length]>0?planning.time1:@"";
    ((UITextField *)[self viewWithTag:104]).text=[planning.distRem1 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.distRem1 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:105]).text =[planning.galUsed1 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galUsed1 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:106]).text=[planning.galRem1 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galRem1 doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:111]).text=[planning.dist2 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.dist2 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:112]).text=[planning.gs2 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.gs2 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:113]).text=[planning.time2 length]>0?planning.time2:@"";
    ((UITextField *)[self viewWithTag:114]).text=[planning.distRem2 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.distRem2 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:115]).text =[planning.galUsed2 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galUsed2 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:116]).text=[planning.galRem2 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galRem2 doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:121]).text=[planning.dist3 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.dist3 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:122]).text=[planning.gs3 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.gs3 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:123]).text=[planning.time3 length]>0?planning.time3:@"";
    ((UITextField *)[self viewWithTag:124]).text=[planning.distRem3 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.distRem3 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:125]).text =[planning.galUsed3 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galUsed3 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:126]).text=[planning.galRem3 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galRem3 doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:131]).text=[planning.dist4 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.dist4 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:132]).text=[planning.gs4 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.gs4 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:133]).text=[planning.time4 length]>0?planning.time4:@"";
    ((UITextField *)[self viewWithTag:134]).text=[planning.distRem4 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.distRem4 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:135]).text =[planning.galUsed4 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galUsed4 doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:136]).text=[planning.galRem4 doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galRem4 doubleValue]]:@"";
    
    ((UITextField *)[self viewWithTag:141]).text=[planning.fuelLoad doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.fuelLoad doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:142]).text=[planning.galHR doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.galHR doubleValue]]:@"";
    ((UITextField *)[self viewWithTag:143]).text=[planning.totalDist doubleValue]>0.0?[NSString stringWithFormat:@"%.01f", [planning.totalDist doubleValue]]:@"";
}

-(void)getSavedFiles {
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context= [appDelegate getContext];
    
    NSEntityDescription *descriptor=[NSEntityDescription entityForName:ENTITY_FLIGHTPLANNING inManagedObjectContext:context];
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

    
    FlightPlanning *planning=[self.arrayFiles objectAtIndex:indexPath.row];
    UITextField *saveTxt = [[UITextField alloc]init];
    saveTxt.borderStyle=UITextBorderStyleRoundedRect;
    saveTxt.frame = CGRectMake(0.0, 0.0, self.saveTableView.bounds.size.width, 30.0);
    saveTxt.textAlignment = NSTextAlignmentCenter;
    saveTxt.userInteractionEnabled = NO;
    saveTxt.text = planning.name;

    [cell.contentView addSubview:saveTxt];
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBackButton" object:nil userInfo:@{@"isBackShow":[NSNumber numberWithBool:YES]}];
    FlightPlanning *planning=[self.arrayFiles objectAtIndex:indexPath.row];
    [self displayDetails:planning];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        FlightPlanning *planning=[self.arrayFiles objectAtIndex:indexPath.row];
        [self deleteFile:planning];
    }
}
-(void)deleteFile:(FlightPlanning*)balance {
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext* moc = [appDelegate getContext];
    [moc deleteObject:balance];
    NSError *error;
    [moc save:&error];
    if (!error) {
        [self.arrayFiles removeObject:balance];
        [self.saveTableView reloadData];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag!=1020) {
        NSString *acceptableCharacter=ACCEPTABLE_CHARECTERS;
        if (textField.tag==103 || textField.tag==113 || textField.tag==123 || textField.tag==123) {
            acceptableCharacter=ACCEPTABLE_TIMECHARECTERS;
        }
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacter] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:[string isEqualToString:filtered]?string:@""];
        
        if ([textField.text containsString:@"."] && [string isEqualToString:@"."] && range.length<1) {
            finalString=[finalString substringToIndex:[finalString length] - 1];
        }
        double newValue=[finalString doubleValue];
        
        [self valueChangedInConversionTableForMeasurement:(textField.tag/10) forUnit:(textField.tag % 10) withNewValue:newValue];
        textField.text = finalString;
        
        return NO;

    }
    return YES;
   }

///-------------------------------------------------
#pragma mark - Measurement Calculations
///-------------------------------------------------

- (void)valueChangedInConversionTableForMeasurement:(CalculationsMeasurement)measurement forUnit:(NSInteger)unitId withNewValue:(double)newValue{
    switch (measurement) {
        case LEG1:
            [self calculateLag1OnChangeInUnit:unitId toNewValue:newValue];
            break;
        case LEG2:
            [self calculateLag2OnChangeInUnit:unitId toNewValue:newValue];
            break;
        case LEG3:
            [self calculateLag3OnChangeInUnit:unitId toNewValue:newValue];
            break;
        case LEG4:
            [self calculateLag4OnChangeInUnit:unitId toNewValue:newValue];
            break;
        case FUELLOAD:
            [self calculateFuelLoadChangeInUnit:unitId toNewValue:newValue];
            break;
       
            
        default:
            break;
    }
}

- (void)calculateLag1OnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *distTextField = [self viewWithTag:101];
    UITextField *gsTextField = [self viewWithTag:102];
    UITextField *timeTextField = [self viewWithTag:103];
   
    UITextField *fuelLoadTextField = [self viewWithTag:141];
    UITextField *galHrTextField = [self viewWithTag:142];
    UITextField *totalDistTextField = [self viewWithTag:143];
  
    double dist=0.00,gs=0.00,time=0.00;
    switch (unitId) {
        case 1:
            dist=newValue;
            gs=[gsTextField.text doubleValue];
            
            break;
        case 2:
            dist=[distTextField.text doubleValue];
            gs=newValue;
           
            break;
        
      
            
        default:
            break;
    }
    if (gs>0.0) {
        time=dist/gs;
    }
    
    distTextField.text=[NSString stringWithFormat:@"%.02f",dist];
    timeTextField.text=time>0.0 ?[self convertDecimalTimeTostring:time]:@"00:00:00";
    gsTextField.text=[NSString stringWithFormat:@"%.01f",gs];
    
    

    [self calculateValues:[fuelLoadTextField.text doubleValue] Gal:[galHrTextField.text doubleValue] totalDist:[totalDistTextField.text doubleValue]];
   
}

- (void)calculateLag2OnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *distTextField = [self viewWithTag:111];
    UITextField *gsTextField = [self viewWithTag:112];
    UITextField *timeTextField = [self viewWithTag:113];
   
    UITextField *fuelLoadTextField = [self viewWithTag:141];
    UITextField *galHrTextField = [self viewWithTag:142];
    UITextField *totalDistTextField = [self viewWithTag:143];
    
    double dist=0.00,gs=0.00,time=0.00;
    switch (unitId) {
        case 1:
            dist=newValue;
            gs=[gsTextField.text doubleValue];
            
            break;
        case 2:
            dist=[distTextField.text doubleValue];
            gs=newValue;
            
            break;
      
        default:
            break;
    }
    if (gs>0.0) {
        time=dist/gs;
    }
    
    
    distTextField.text=[NSString stringWithFormat:@"%.02f",dist];
    timeTextField.text=time>0.0 ?[self convertDecimalTimeTostring:time]:@"00:00:00";
    gsTextField.text=[NSString stringWithFormat:@"%.01f",gs];
   
    [self calculateValues:[fuelLoadTextField.text doubleValue] Gal:[galHrTextField.text doubleValue] totalDist:[totalDistTextField.text doubleValue]];

    
    
    
   
}
- (void)calculateLag3OnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *distTextField = [self viewWithTag:121];
    UITextField *gsTextField = [self viewWithTag:122];
    UITextField *timeTextField = [self viewWithTag:123];
    
    UITextField *fuelLoadTextField = [self viewWithTag:141];
    UITextField *galHrTextField = [self viewWithTag:142];
    UITextField *totalDistTextField = [self viewWithTag:143];
   

    
    double dist=0.00,gs=0.00,time=0.00;
    switch (unitId) {
        case 1:
            dist=newValue;
            gs=[gsTextField.text doubleValue];
            
            break;
        case 2:
            dist=[distTextField.text doubleValue];
            gs=newValue;
            
            break;
            
        default:
            break;
    }
    if (gs>0.0) {
        time=dist/gs;
    }
    
  
    
    distTextField.text=[NSString stringWithFormat:@"%.02f",dist];
    timeTextField.text=time>0.0 ?[self convertDecimalTimeTostring:time]:@"00:00:00";
    gsTextField.text=[NSString stringWithFormat:@"%.01f",gs];
   
    
    
    
    
  [self calculateValues:[fuelLoadTextField.text doubleValue] Gal:[galHrTextField.text doubleValue] totalDist:[totalDistTextField.text doubleValue]];
}
- (void)calculateLag4OnChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *distTextField = [self viewWithTag:131];
    UITextField *gsTextField = [self viewWithTag:132];
    UITextField *timeTextField = [self viewWithTag:133];
    
    UITextField *fuelLoadTextField = [self viewWithTag:141];
    UITextField *galHrTextField = [self viewWithTag:142];
    UITextField *totalDistTextField = [self viewWithTag:143];
  

    double dist=0.00,gs=0.00,time=0.00;
    switch (unitId) {
        case 1:
            dist=newValue;
            gs=[gsTextField.text doubleValue];
            
            break;
        case 2:
            dist=[distTextField.text doubleValue];
            gs=newValue;
            
            break;
            
        default:
            break;
    }
    if (gs>0.0) {
        time=dist/gs;
    }
  
    
    distTextField.text=[NSString stringWithFormat:@"%.02f",dist];
    timeTextField.text=time>0.0 ?[self convertDecimalTimeTostring:time]:@"00:00:00";
    gsTextField.text=[NSString stringWithFormat:@"%.01f",gs];
    
    
      [self calculateValues:[fuelLoadTextField.text doubleValue] Gal:[galHrTextField.text doubleValue] totalDist:[totalDistTextField.text doubleValue]];
    
    
}
-(void)calculateFuelLoadChangeInUnit:(NSInteger)unitId toNewValue:(double)newValue {
    UITextField *fuelLoadTextField = [self viewWithTag:141];
    UITextField *galHrTextField = [self viewWithTag:142];
    UITextField *totalDistTextField = [self viewWithTag:143];
    double fuelValue=0.0,galValue=0.0,totalValue=0.0;
    switch (unitId) {
        case 1:
            fuelValue=newValue;
            galValue=[galHrTextField.text doubleValue];
            totalValue=[totalDistTextField.text doubleValue];
            break;
        case 2:
            fuelValue=[fuelLoadTextField.text doubleValue];
            galValue=newValue;
            totalValue=[totalDistTextField.text doubleValue];
            break;
        case 3:
            fuelValue=[fuelLoadTextField.text doubleValue];
            galValue=[galHrTextField.text doubleValue];
            totalValue=newValue;
            break;
            
        default:
            break;
    }
    fuelLoadTextField.text=[NSString stringWithFormat:@"%.01f",fuelValue];
    galHrTextField.text=[NSString stringWithFormat:@"%.01f",galValue ];
    totalDistTextField.text=[NSString stringWithFormat:@"%.01f",totalValue ];
    [self calculateValues:fuelValue Gal:galValue totalDist:totalValue];

}

-(void)calculateValues:(double)fuelValue Gal:(double)galValue totalDist:(double)distValue {
    
    UITextField *distTextField = [self viewWithTag:101];
    UITextField *timeTextField = [self viewWithTag:103];
    UITextField *distRemTextField = [self viewWithTag:104];
    UITextField *galUsedTextField = [self viewWithTag:105];
    UITextField *galRemTextField = [self viewWithTag:106];
    
    UITextField *dist2TextField = [self viewWithTag:111];
    UITextField *time2TextField = [self viewWithTag:113];
    UITextField *dist2RemTextField = [self viewWithTag:114];
    UITextField *gal2UsedTextField = [self viewWithTag:115];
    UITextField *gal2RemTextField = [self viewWithTag:116];
    
    UITextField *dist3TextField = [self viewWithTag:121];
    UITextField *time3TextField = [self viewWithTag:123];
    UITextField *dist3RemTextField = [self viewWithTag:124];
    UITextField *gal3UsedTextField = [self viewWithTag:125];
    UITextField *gal3RemTextField = [self viewWithTag:126];
    
    UITextField *dist4TextField = [self viewWithTag:131];
    UITextField *time4TextField = [self viewWithTag:133];
    UITextField *dist4RemTextField = [self viewWithTag:134];
    UITextField *gal4UsedTextField = [self viewWithTag:135];
    UITextField *gal4RemTextField = [self viewWithTag:136];
    
   distRemTextField.text=distValue>0.0?[NSString stringWithFormat:@"%.01f",distValue-[distTextField.text doubleValue]]:@"0.0";
   double time=[self getMinutesFromString:timeTextField.text];
   double galUsed=time>0.0?(galValue/60)*time:0.0;
   galUsedTextField.text=galUsed>0.0?[NSString stringWithFormat:@"%.01f",galUsed ]:@"";
    galRemTextField.text=fuelValue>0.0?[NSString stringWithFormat:@"%.01f",fuelValue-galUsed ]:@"";
    
    dist2RemTextField.text=[distRemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[distRemTextField.text doubleValue]-[dist2TextField.text doubleValue]]:@"";
     time=[self getMinutesFromString:time2TextField.text];
     galUsed=time>0.0?(galValue/60)*time:0.0;
    gal2UsedTextField.text=galUsed>0.0?[NSString stringWithFormat:@"%.01f",galUsed ]:@"";
    gal2RemTextField.text=[galRemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[galRemTextField.text doubleValue]-galUsed ]:@"";
    
    dist3RemTextField.text=[dist2RemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[dist2RemTextField.text doubleValue]-[dist3TextField.text doubleValue]]:@"";
    time=[self getMinutesFromString:time3TextField.text];
    galUsed=time>0.0?(galValue/60)*time:0.0;
    gal3UsedTextField.text=galUsed>0.0?[NSString stringWithFormat:@"%.01f",galUsed ]:@"";
    gal3RemTextField.text=[gal2RemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[gal2RemTextField.text doubleValue]-galUsed ]:@"";
  
    
    dist4RemTextField.text=[dist3RemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[dist3RemTextField.text doubleValue]-[dist4TextField.text doubleValue]]:@"";
    time=[self getMinutesFromString:time4TextField.text];
    galUsed=time>0.0?(galValue/60)*time:0.0;
    gal4UsedTextField.text=galUsed>0.0?[NSString stringWithFormat:@"%.01f",galUsed ]:@"";
    gal4RemTextField.text=[gal3RemTextField.text doubleValue]>0.0?[NSString stringWithFormat:@"%.01f",[gal3RemTextField.text doubleValue]-galUsed ]:@"";
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
-(double)getMinutesFromString:(NSString*)time {
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
    
   // minutes=minutes/60;
    
    return (hours*60)+minutes+(second/60);
    
}

-(double)getMinutesFromDecimal:(double)hours {
    float minutes;
    
    int hour=0,minute=0,second;
    
    hour=floor(hours);
    
    minutes=(hours-hour)*60;
    
    minute=floor(minutes);
    
    second=(minutes-minute)*60;
    NSLog(@"minutes:-%f",(hour*60.0)+minute);
    return (hour*60.0)+minute+(second/60);

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
@end

//
//  FliteCalcViewController.m
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import "FliteCalcViewController.h"

#import "SectionHeaderView.h"
#import "CalculatorViewController.h"
#import "ConversionsCell.h"
#import "CalculationsCell.h"
#import "WeightAndBalanceCell.h"
#import "PerformanceCell.h"
#import "FlightPlanningCell.h"

#import "Constants.h"

#define RowHeight 380

@interface FliteCalcViewController ()<UITableViewDelegate, UITableViewDataSource, KeyboardDelegate>
{
    ConversionsCell *conversionsCell;
    CalculationsCell *calculationsCell;
    WeightAndBalanceCell *weightAndBalanceCell;
    PerformanceCell *performanceCell;
    FlightPlanningCell *flightPlanningCell;
    
    UITextField *activeTextField;
    NSMutableArray *collapsedSections;
}
@property (assign, nonatomic)BOOL isBackButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FliteCalcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBackButton = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConversionsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ConversionsCell"];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"CalculationsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CalculationsCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WeightAndBalanceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"weightAndBalanceCell"];
    
    collapsedSections = [[NSMutableArray alloc] initWithObjects: [NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4], nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PerformanceCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"performanceCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FlightPlanningCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"flightPlanningCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backButton:) name:@"ShowBackButton" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Add Keyboard Notifications
//    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated{
    // Remove Keyboard Notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///------------------------------------------------------------
#pragma mark - Keyboard Handling
///------------------------------------------------------------
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (activeTextField != nil) {
        CGRect activeTextFieldFrame = [self.view convertRect:activeTextField.frame fromView:activeTextField.superview.superview.superview];
        
        if (!CGRectContainsPoint(aRect, activeTextFieldFrame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeTextFieldFrame.origin.y-kbSize.height);
            [self.tableView setContentOffset:scrollPoint animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

///------------------------------------------------------------
#pragma marl - UITableViewDataSource Methods
///------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([collapsedSections containsObject:[NSNumber numberWithInteger:section]]) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 840;
    }else if (indexPath.section==1) {
        return 1000;
    }else if (indexPath.section==2) {
        return 2140;}
    else if (indexPath.section==3) {
        return 1100;}
    else if (indexPath.section==4) {
            return 1100;}else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (!conversionsCell) {
            conversionsCell = [tableView dequeueReusableCellWithIdentifier:@"ConversionsCell"];
            conversionsCell.keyboardDelegate = self;
        }
        return conversionsCell;
    }
    else if (indexPath.section == 1){
        if (!calculationsCell) {
            calculationsCell = [tableView dequeueReusableCellWithIdentifier:@"CalculationsCell"];
        }
        return calculationsCell;
    }
    else if (indexPath.section == 2){
        if (!weightAndBalanceCell) {
            
            weightAndBalanceCell = [tableView dequeueReusableCellWithIdentifier:@"weightAndBalanceCell"];
        }
        return weightAndBalanceCell;
    }
    else if (indexPath.section == 3){
        if (!performanceCell) {
            
            performanceCell = [tableView
                               dequeueReusableCellWithIdentifier:@"performanceCell"];
            
        }
        return performanceCell;
    }
    else if (indexPath.section == 4){
        if (!flightPlanningCell) {
            
            flightPlanningCell = [tableView
                               dequeueReusableCellWithIdentifier:@"flightPlanningCell"];
        }
        return flightPlanningCell;
    }
    else
        return [[UITableViewCell alloc] init];
}

///------------------------------------------------------------
#pragma marl - UITableViewDelegate Methods
///------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderView *sectionHeaderView = [SectionHeaderView sectionHeaderView];
    sectionHeaderView.sectionIndex = section;
    
    if (section == 0) {
        sectionHeaderView.headerTitleLabel.text = @"CONVERSIONS";
    }
    else if (section == 1){
        sectionHeaderView.headerTitleLabel.text = @"CALCULATIONS";
    }
    else if (section == 2){
        sectionHeaderView.headerTitleLabel.text = @"WEIGHT AND BALANCE";
       // sectionHeaderView.wtClearAllBtn.hidden = NO;
//        if (self.isBackButton==YES) {
//            sectionHeaderView.wtBackBtn.hidden = NO;
//        }else
//            sectionHeaderView.wtBackBtn.hidden = YES;
        
    }
    else if (section == 3){
        sectionHeaderView.headerTitleLabel.text = @"PERFORMANCE";
    }
    else if (section == 4){
        sectionHeaderView.headerTitleLabel.text = @"FLIGHT PLANNING";
    }

    sectionHeaderView.headerTitleLabel.textColor=[UIColor blueColor];
    // Change the arrow direction if the section is collapsed
    if ([collapsedSections containsObject:[NSNumber numberWithInteger:section]]) {
        [sectionHeaderView.dropDownButton setSelected:YES];
    }
    else{
        [sectionHeaderView.dropDownButton setSelected:NO];
    }
    
    // Add gesture recognizer on the section header
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    [sectionHeaderView addGestureRecognizer:tapGesture];
    
    return sectionHeaderView;
}

///------------------------------------------------------------
#pragma mark - KeyboardDelegate Methods
///------------------------------------------------------------
- (void)keyboardWillPresentForTextField:(UITextField *)textField{
    
    // Save current active textfield
    activeTextField = textField;
}

///------------------------------------------------------------
#pragma mark - Gesture Recognizers
///------------------------------------------------------------
- (void)tapRecognized:(UITapGestureRecognizer *)tapGesture{
    
    if ([tapGesture.view isKindOfClass:[SectionHeaderView class]]) {
        // Expand/Collapse the section
        
        SectionHeaderView *sectionHeader = (SectionHeaderView *)tapGesture.view;
        
        NSInteger result = [collapsedSections indexOfObject:[NSNumber numberWithInteger:sectionHeader.sectionIndex]];
        
        if (result == NSNotFound) {
            [collapsedSections addObject:[NSNumber numberWithInteger:sectionHeader.sectionIndex]];
        }
        else{
            [collapsedSections removeObjectAtIndex:result];
        }
        
        // Refresh the tableview to expand/collapse the section
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionHeader.sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
- (IBAction)actionClearAll:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [NSUserDefaults resetStandardUserDefaults];
    [prefs synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SavedText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearText" object:nil];
}

- (IBAction)actionCalculator:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"SHOW_CALC" object: nil];
//    CalculatorViewController *VC = [[CalculatorViewController alloc] init];
//    //VC.view.frame=CGRectMake(0,10, 320, 500);
//    
//    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:VC];
//    popoverController.delegate = self;
//    
//    [popoverController setPopoverContentSize:CGSizeMake(320, 420) animated:NO];
//    [popoverController presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)backButton:(NSNotification*)notification {
    self.isBackButton=[[notification.userInfo objectForKey:@"isBackShow"] boolValue];
    [self.tableView reloadData];
}

- (IBAction)actionSave:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveText" object:nil];
}
@end

//
//  FlightPlanningCell.h
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@interface FlightPlanningCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)IBOutlet UITableView *saveTableView;

@property (nonatomic, weak) id <KeyboardDelegate> keyboardDelegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTxtField;
@property (weak,nonatomic)IBOutlet UIButton *saveFlightBtn;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *arrayFiles;
@end

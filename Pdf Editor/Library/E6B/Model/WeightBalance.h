//
//  WeightBalance.h
//  FliteCalculators
//
//  Created by inextsol on 11/8/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface WeightBalance : NSManagedObject
@property (nullable,  nonatomic, strong)NSString* name;
@property (nullable, nonatomic, retain) NSNumber * basicEmptyWeight;
@property (nullable, nonatomic, retain) NSNumber * basicEmptyArm;
@property (nullable, nonatomic, retain) NSNumber * basicEmptyMoment;
@property (nullable, nonatomic, retain) NSNumber * frontPaxWeight;
@property (nullable, nonatomic, retain) NSNumber * frontPaxArm;
@property (nullable, nonatomic, retain) NSNumber * frontPaxMoment;
@property (nullable, nonatomic, retain) NSNumber * frontPax2Weight;
@property (nullable, nonatomic, retain) NSNumber * frontPax2Arm;
@property (nullable, nonatomic, retain) NSNumber * frontPax2Moment;
@property (nullable, nonatomic, retain) NSNumber * backPaxWeight;
@property (nullable, nonatomic, retain) NSNumber * backPaxArm;
@property (nullable, nonatomic, retain) NSNumber * backPaxMoment;
@property (nullable, nonatomic, retain) NSNumber * backPax2Weight;
@property (nullable, nonatomic, retain) NSNumber * backPax2Arm;
@property (nullable, nonatomic, retain) NSNumber * backPax2Moment;
@property (nullable, nonatomic, retain) NSNumber * cargo1Weight;
@property (nullable, nonatomic, retain) NSNumber * cargo1Arm;
@property (nullable, nonatomic, retain) NSNumber * cargo1Moment;
@property (nullable, nonatomic, retain) NSNumber * cargo2Weight;
@property (nullable, nonatomic, retain) NSNumber * cargo2Arm;
@property (nullable, nonatomic, retain) NSNumber * cargo2Moment;
@property (nullable, nonatomic, retain) NSNumber * emptyFuelWeight;
@property (nullable, nonatomic, retain) NSNumber * emptyFuelArm;
@property (nullable, nonatomic, retain) NSNumber * emptyFuelMoment;
@property (nullable, nonatomic, retain) NSNumber * mainTanksWeight;
@property (nullable, nonatomic, retain) NSNumber * mainTanksArm;
@property (nullable, nonatomic, retain) NSNumber * mainTanksMoment;
@property (nullable, nonatomic, retain) NSNumber * mainTanksWeightGl;
@property (nullable, nonatomic, retain) NSNumber * auxTankweight;
@property (nullable, nonatomic, retain) NSNumber * auxTankWeightGl;
@property (nullable, nonatomic, retain) NSNumber * auxTankArm;
@property (nullable, nonatomic, retain) NSNumber * auxTankMoment;
@property (nullable, nonatomic, retain) NSNumber * totalWeight;
@property (nullable, nonatomic, retain) NSNumber * totalArm;
@property (nullable, nonatomic, retain) NSNumber * totalMoment;
@property (nullable, nonatomic, retain) NSNumber * maxGrossWeight;
@property (nullable, nonatomic, retain) NSNumber * maxTakeOffWeight;
@property (nullable, nonatomic, retain) NSNumber * maxLandingWeight;
@property (nullable, nonatomic, retain) NSNumber * maxEmptyFuelWeight;
@property (nullable, nonatomic, retain) NSNumber * maxCargo1Weight;
@property (nullable, nonatomic, retain) NSNumber * maxCargo2Weight;
@property (nullable, nonatomic, retain) NSNumber * cgGrossWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cgGrossWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cgTakeOffWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cgTakeOffweightMax;
@property (nullable, nonatomic, retain) NSNumber * cgEmptyFuelWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cgEmptyFuelWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cgBasicEmptyWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cgBasicEmptyWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cg2BasicEmptyWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cg2BasicEmptyWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cg2EmptyFuelWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cg2EmptyFuelWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cg2GrossWeightMax;
@property (nullable, nonatomic, retain) NSNumber * cg2GrossWeightMin;
@property (nullable, nonatomic, retain) NSNumber * cg2TakeOffweightMax;
@property (nullable, nonatomic, retain) NSNumber * cg2TakeOffweightMin;




@end

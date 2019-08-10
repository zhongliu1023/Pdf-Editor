//
//  FlightPlanning+CoreDataProperties.h
//  FliteCalculators
//
//  Created by inextsol on 11/10/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FlightPlanning.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlightPlanning (CoreDataProperties)
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *dist1;
@property (nullable, nonatomic, retain) NSNumber *dist2;
@property (nullable, nonatomic, retain) NSNumber *dist3;
@property (nullable, nonatomic, retain) NSNumber *dist4;
@property (nullable, nonatomic, retain) NSNumber *distRem1;
@property (nullable, nonatomic, retain) NSNumber *distRem2;
@property (nullable, nonatomic, retain) NSNumber *distRem3;
@property (nullable, nonatomic, retain) NSNumber *distRem4;
@property (nullable, nonatomic, retain) NSNumber *fuelLoad;
@property (nullable, nonatomic, retain) NSNumber *galHR;
@property (nullable, nonatomic, retain) NSNumber *galRem1;
@property (nullable, nonatomic, retain) NSNumber *galRem2;
@property (nullable, nonatomic, retain) NSNumber *galRem3;
@property (nullable, nonatomic, retain) NSNumber *galRem4;
@property (nullable, nonatomic, retain) NSNumber *galUsed1;
@property (nullable, nonatomic, retain) NSNumber *galUsed2;
@property (nullable, nonatomic, retain) NSNumber *galUsed3;
@property (nullable, nonatomic, retain) NSNumber *galUsed4;
@property (nullable, nonatomic, retain) NSNumber *gs1;
@property (nullable, nonatomic, retain) NSNumber *gs2;
@property (nullable, nonatomic, retain) NSNumber *gs3;
@property (nullable, nonatomic, retain) NSNumber *gs4;
@property (nullable, nonatomic, retain) NSString *time1;
@property (nullable, nonatomic, retain) NSString *time2;
@property (nullable, nonatomic, retain) NSString *time3;
@property (nullable, nonatomic, retain) NSString *time4;
@property (nullable, nonatomic, retain) NSNumber *totalDist;

@end

NS_ASSUME_NONNULL_END

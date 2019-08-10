//
//  Calculations+CoreDataProperties.h
//  FliteCalculators
//
//  Created by inext on 11/22/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Calculations.h"

NS_ASSUME_NONNULL_BEGIN

@interface Calculations (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cloudBasesBases;
@property (nullable, nonatomic, retain) NSNumber *cloudBasesDew;
@property (nullable, nonatomic, retain) NSNumber *cloudBaseTemp;
@property (nullable, nonatomic, retain) NSNumber *daAlt;
@property (nullable, nonatomic, retain) NSNumber *daBaro;
@property (nullable, nonatomic, retain) NSNumber *daDa;
@property (nullable, nonatomic, retain) NSNumber *daDew;
@property (nullable, nonatomic, retain) NSNumber *daTemp;
@property (nullable, nonatomic, retain) NSNumber *etaKts;
@property (nullable, nonatomic, retain) NSNumber *etaNm;
@property (nullable, nonatomic, retain) NSNumber *etaSm;
@property (nullable, nonatomic, retain) NSNumber *etaTime;
@property (nullable, nonatomic, retain) NSNumber *freezlingLevelFT;
@property (nullable, nonatomic, retain) NSNumber *freezlingLevelTemp;
@property (nullable, nonatomic, retain) NSNumber *fuelBurnFuelBurn;
@property (nullable, nonatomic, retain) NSNumber *fuelBurnFuelUsed;
@property (nullable, nonatomic, retain) NSString *fuelBurnTime;
@property (nullable, nonatomic, retain) NSNumber *fuelBurnTimeDec;
@property (nullable, nonatomic, retain) NSNumber *fuelNmGalFuelBurn;
@property (nullable, nonatomic, retain) NSNumber *fuelNmGalGalNm;
@property (nullable, nonatomic, retain) NSNumber *fuelNmGalNm;
@property (nullable, nonatomic, retain) NSNumber *fuelNmGalNmGal;
@property (nullable, nonatomic, retain) NSNumber *fuelNmGalTimeDec;
@property (nullable, nonatomic, retain) NSNumber *glidingAlt;
@property (nullable, nonatomic, retain) NSNumber *glidingDistNM;
@property (nullable, nonatomic, retain) NSNumber *glidingDistSM;
@property (nullable, nonatomic, retain) NSNumber *glidingIas;
@property (nullable, nonatomic, retain) NSNumber *glidingRatio;
@property (nullable, nonatomic, retain) NSString *glidingTimeAloft;
@property (nullable, nonatomic, retain) NSNumber *isaAlt;
@property (nullable, nonatomic, retain) NSNumber *isaBaro;
@property (nullable, nonatomic, retain) NSNumber *isaDiffCelcius;
@property (nullable, nonatomic, retain) NSNumber *isaDiffFeet;
@property (nullable, nonatomic, retain) NSNumber *isaTemp;
@property (nullable, nonatomic, retain) NSNumber *paAlt;
@property (nullable, nonatomic, retain) NSNumber *paBaro;
@property (nullable, nonatomic, retain) NSNumber *paMillibars;
@property (nullable, nonatomic, retain) NSNumber *paPa;
@property (nullable, nonatomic, retain) NSNumber *tasalt;
@property (nullable, nonatomic, retain) NSNumber *tasAs;
@property (nullable, nonatomic, retain) NSNumber *tasTas;
@property (nullable, nonatomic, retain) NSNumber *timeDistanceKts;
@property (nullable, nonatomic, retain) NSNumber *timeDistanceNm;
@property (nullable, nonatomic, retain) NSNumber *timeDistanceSm;
@property (nullable, nonatomic, retain) NSString *timeDistanceTime;

@end

NS_ASSUME_NONNULL_END

//
//  Conversions+CoreDataProperties.h
//  FliteCalculators
//
//  Created by inext on 11/22/16.
//  Copyright © 2016 RAZZOR. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Conversions.h"

NS_ASSUME_NONNULL_BEGIN

@interface Conversions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *admosBaro;
@property (nullable, nonatomic, retain) NSNumber *admosMillibars;
@property (nullable, nonatomic, retain) NSNumber *admosPsi;
@property (nullable, nonatomic, retain) NSNumber *attribute;
@property (nullable, nonatomic, retain) NSNumber *diatanceNautical;
@property (nullable, nonatomic, retain) NSNumber *distanceFeet;
@property (nullable, nonatomic, retain) NSNumber *distanceKilometer;
@property (nullable, nonatomic, retain) NSNumber *distanceMiles;
@property (nullable, nonatomic, retain) NSNumber *fluidGallons;
@property (nullable, nonatomic, retain) NSNumber *fluidLiters;
@property (nullable, nonatomic, retain) NSNumber *fluidOunces;
@property (nullable, nonatomic, retain) NSNumber *fluidPints;
@property (nullable, nonatomic, retain) NSNumber *fluidQuarts;
@property (nullable, nonatomic, retain) NSNumber *fuelAvGas;
@property (nullable, nonatomic, retain) NSNumber *fuelJetA;
@property (nullable, nonatomic, retain) NSNumber *fuelOil;
@property (nullable, nonatomic, retain) NSNumber *fuelPounds;
@property (nullable, nonatomic, retain) NSNumber *fuelTks;
@property (nullable, nonatomic, retain) NSNumber *fuelWater;
@property (nullable, nonatomic, retain) NSNumber *speedKph;
@property (nullable, nonatomic, retain) NSNumber *speedKts;
@property (nullable, nonatomic, retain) NSNumber *speedMph;
@property (nullable, nonatomic, retain) NSNumber *tempCelcius;
@property (nullable, nonatomic, retain) NSNumber *tempfarnate;
@property (nullable, nonatomic, retain) NSNumber *tempKelbin;
@property (nullable, nonatomic, retain) NSNumber *timeDecimal;
@property (nullable, nonatomic, retain) NSString *timeEnd;
@property (nullable, nonatomic, retain) NSString *timeStart;
@property (nullable, nonatomic, retain) NSString *timeTotal;
@property (nullable, nonatomic, retain) NSString *timeZoneLocal;
@property (nullable, nonatomic, retain) NSString *timeZoneLosAngeles;
@property (nullable, nonatomic, retain) NSString *timeZoneZULU;
@property (nullable, nonatomic, retain) NSNumber *weightKilos;
@property (nullable, nonatomic, retain) NSNumber *weightPound;
@property (nullable, nonatomic, retain) NSNumber *weightTons;

@end

NS_ASSUME_NONNULL_END

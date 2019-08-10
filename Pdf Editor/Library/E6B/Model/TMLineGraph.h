//
//  TMLineGraph.h
//  GraphDemo
//
//  Created by inextsol on 11/9/16.
//  Copyright © 2016 inextsol. All rights reserved.
//

#import <UIKit/UIKit.h>
#define UULabelHeight   240

@interface TMLineGraph : UIView
@property(assign,nonatomic) float levelY,levelX;
@property (strong,nonatomic)NSArray *yArray;
@property (strong,nonatomic)NSArray *xArray;
-(void)addHorizontalLabel:(NSArray*)array;
-(void)addVerticalLabel:(NSArray*)array;
-(void)drawGraph:(NSArray*)points color:(UIColor *)colorValue shapeLayer:(CAShapeLayer *)shapeLayerGraph;
-(void)drawGraphArm:(NSArray*)points;
@property (nonatomic) CGFloat yValueMin,xValueMin;
@property (nonatomic) CGFloat yValueMax,xValueMax;
@end

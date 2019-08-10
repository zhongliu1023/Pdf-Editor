//
//  SectionHeaderView.m
//  FliteCalculators
//
//  Created by RAZZOR on 21/09/16.
//  Copyright © 2016 NOVA Aviation. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView


- (IBAction)actionClearAll:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClearWeightText" object:nil];
}

- (IBAction)backAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackWeightText" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBackButton" object:nil userInfo:@{@"isBackShow":[NSNumber numberWithBool:NO]}];
}

+ (instancetype)sectionHeaderView{
    // Create an instance of SectionHeaderView
    SectionHeaderView *sectionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:nil options:nil] firstObject];
    
    if ([sectionHeaderView isKindOfClass:[SectionHeaderView class]]) {
        
        return sectionHeaderView;
    }
    
    return nil;
}

@end

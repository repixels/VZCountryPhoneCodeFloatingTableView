//
//  FloatingCountriesTableDelegate.h
//  Floating TableView
//
//  Created by Ehab Ashraf on 4/1/17.
//  Copyright © 2017 Vezeeta. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FloatingCountriesTableDelegate <NSObject>

@optional
-(void) didSelectCountry:(Country*)selectedCountry;

@required
-(void) didDismissViewController;
-(void) didFinishSelectionWithCountry:(Country *)selectedCountry;

@end

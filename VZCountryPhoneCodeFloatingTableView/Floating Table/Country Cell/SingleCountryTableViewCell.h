//
//  SingleCountryTableViewCell.h
//  Floating TableView
//
//  Created by Ehab Ashraf on 4/1/17.
//  Copyright © 2017 Vezeeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Country.h"

@interface SingleCountryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *countryFlag;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *countryCode;

@property (weak, nonatomic) Country *cellCountry;

@end

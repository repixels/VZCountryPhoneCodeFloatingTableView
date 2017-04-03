//
//  SingleCountryTableViewCell.m
//  Floating TableView
//
//  Created by Ehab Ashraf on 4/1/17.
//  Copyright © 2017 Vezeeta. All rights reserved.
//

#import "SingleCountryTableViewCell.h"

@implementation SingleCountryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - Setters and Getters
-(void) setCellCountry:(Country *)cellCountry
{
    if(cellCountry != nil)
    {
        self.countryName.text = cellCountry.countryName;
        
        self.countryFlag.image = [UIImage imageNamed:[cellCountry.countryISO2Code uppercaseString]] != nil ? [UIImage imageNamed:[cellCountry.countryISO2Code uppercaseString]] : [UIImage imageNamed:@"WW"];
        
        self.countryCode.text = [NSString stringWithFormat:@"+%@",cellCountry.countryPhoneCode];
    }
}


@end

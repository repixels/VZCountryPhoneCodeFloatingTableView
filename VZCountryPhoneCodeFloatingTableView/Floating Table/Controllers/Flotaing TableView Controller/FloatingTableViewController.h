//
//  FloatingTableViewController.h
//  Floating TableView
//
//  Created by Ehab Ashraf on 4/1/17.
//  Copyright © 2017 Vezeeta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCountryTableViewCell.h"
#import "CountryListDataSource.h"
#import "CGLAlphabetizer.h"
#import "Country.h"
#import "FloatingCountriesTableDelegate.h"


@interface FloatingTableViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic, weak) id<FloatingCountriesTableDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITableView *floatingTableView;

@property (nonatomic,strong) NSString *selectedCountryISOCode;

-(void)loadFloatingTable;

-(instancetype) initWithViewController:(UIViewController*)parentViewController;

-(instancetype) init __attribute__((unavailable("USE initWithViewController: INSTEAD")));

@end

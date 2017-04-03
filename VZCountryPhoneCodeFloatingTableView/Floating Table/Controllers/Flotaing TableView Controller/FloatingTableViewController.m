//
//  FloatingTableViewController.m
//  Floating TableView
//
//  Created by Ehab Ashraf on 4/1/17.
//  Copyright © 2017 Vezeeta. All rights reserved.
//

#import "FloatingTableViewController.h"

@interface FloatingTableViewController ()

@property (nonatomic,strong) NSArray *countryList;
@property (nonatomic) NSDictionary *alphabetizedDictionary;
@property (nonatomic) NSArray *sectionIndexTitles;
@property (nonatomic,strong) Country* selectedCountry;

@property (nonatomic,strong) NSString* selectedCountryName;

@property (nonatomic,weak) UIViewController *callerViewController;


@end

@implementation FloatingTableViewController

#pragma mark - Intialization Methods

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self = [self initWithNibName:@"FloatingTable" bundle:nil];
        
        [self bindTapGesture];
        [self configureDataSource];
        
    }
    return self;
}

-(instancetype) initWithViewController:(UIViewController*)parentViewController
{
    self = [super init];
    if (self)
    {
        self = [self initWithNibName:@"FloatingTable" bundle:nil];
        self.callerViewController = parentViewController;
        [self bindTapGesture];
        [self configureDataSource];
    }
    return self;
}

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self configurTableView];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    if(self.selectedCountryISOCode != nil && self.selectedCountryISOCode.length >1)
    {
        self.selectedCountryName = [self getCountryNameByISO2Code:self.selectedCountryISOCode];
        
        NSArray *sectionCountries = self.alphabetizedDictionary[[self.selectedCountryName substringToIndex:1]];
        
        NSInteger selectCountryIndex = 0;
        
        for(Country *singleCountry in sectionCountries)
        {
            
            if([[singleCountry.countryISO2Code lowercaseString] isEqualToString:[self.selectedCountryISOCode lowercaseString]])
            {
                break;
            }
            
            selectCountryIndex++;
        }
        
        NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:selectCountryIndex inSection:[self.sectionIndexTitles indexOfObject:[self.selectedCountryName substringToIndex:1]]];
        
        [self.floatingTableView selectRowAtIndexPath:selectionIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    
}

#pragma mark - Loading Methods

-(void)loadFloatingTable
{
    CGRect frame = self.view.frame;
    frame.size.width = self.callerViewController.view.frame.size.width ;
    frame.size.height = self.callerViewController.view.frame.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    self.view.frame = frame;
    
    [self.callerViewController.view addSubview:self.view];
    
    [self showAnimateForView];
    
    [self.callerViewController addChildViewController:self];
}

- (void)showAnimateForView
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimateForView
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
}

#pragma mark - Helper Functions
-(NSString *) getCountryNameByISO2Code:(NSString *) countryCode
{
    for(int i = 0 ; i < [self.countryList count] ; i++)
    {
        if([[[self.countryList[i] valueForKey:@"countryISO2Code"] uppercaseString] isEqualToString:[self.selectedCountryISOCode uppercaseString]])
        {
            return [self.countryList[i] valueForKey:@"countryName"];
        }
    }
    
    return nil;
}

#pragma mark - Data Source Configuration
-(void) configureDataSource
{
    CountryListDataSource *countryListDataSource = [[CountryListDataSource alloc] init];
    
    self.countryList = [countryListDataSource countries];
    self.alphabetizedDictionary = [CGLAlphabetizer alphabetizedDictionaryFromObjects:self.countryList usingKeyPath:@"countryName"];
    self.sectionIndexTitles = [CGLAlphabetizer indexTitlesFromAlphabetizedDictionary:self.alphabetizedDictionary];
}

#pragma mark - UITapGesture Binding
-(void) bindTapGesture
{
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    
    [self.backgroundView addGestureRecognizer:singleFingerTap];

}


#pragma mark - Selectors
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissViewController)]) {
        
        [self.delegate didDismissViewController];
    }
}

#pragma mark - UITableView Configuration
-(void) configurTableView
{
    self.floatingTableView.delegate = self;
    self.floatingTableView.dataSource = self;
    
    [self.floatingTableView registerNib:[UINib nibWithNibName:@"SingleCountryTableViewCell" bundle:nil] forCellReuseIdentifier:@"SingleCountryCell"];
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionIndexTitles count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionIndexTitle = self.sectionIndexTitles[section];
    return [self.alphabetizedDictionary[sectionIndexTitle] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleCountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleCountryCell"];
    
    NSString *sectionIndexTitle = self.sectionIndexTitles[indexPath.section];
    
    [cell setCellCountry:self.alphabetizedDictionary[sectionIndexTitle][indexPath.row]];
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectCountry:)]) {
        
        NSString *sectionIndexTitle = self.sectionIndexTitles[indexPath.section];
        
        _selectedCountry = self.alphabetizedDictionary[sectionIndexTitle][indexPath.row];
        

        [self.delegate didSelectCountry:_selectedCountry];
    }
    
}

#pragma mark - IBActions
- (IBAction)didTapDone:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishSelectionWithCountry:)])
    {
        [self.delegate didFinishSelectionWithCountry:_selectedCountry];
        [self removeAnimateForView];
        
        [self deallocProperties];
    }
    
}

- (IBAction)didTapCancel:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissViewController)]) {
        
        [self removeAnimateForView];
        [self.delegate didDismissViewController];
        [self deallocProperties];
    }
}

#pragma mark - Setters and Getters

-(void)setSelectedCountryISOCode:(NSString *)selectedCountryISOCode
{
    _selectedCountryISOCode = selectedCountryISOCode;
    
    if(selectedCountryISOCode != nil && selectedCountryISOCode.length > 1)
    {
        for(int i = 0 ; i < [self.countryList count] ; i++)
        {
            if([[[self.countryList[i] valueForKey:@"countryISO2Code"] uppercaseString] isEqualToString:[selectedCountryISOCode uppercaseString]])
            {
                self.selectedCountry = self.countryList[i];
            }
        }
    }
}

#pragma mark - Dealloc Method
-(void)deallocProperties
{
    self.delegate = nil;
    self.callerViewController = nil;
    self.selectedCountry = nil;
}

-(void) dealloc
{
    NSLog(@"%@ has been deallocated.",[self class]);
}

@end

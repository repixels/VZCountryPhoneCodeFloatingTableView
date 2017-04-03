//
//  CountryListDataSource.m
//  Country List
//
//  Created by Pradyumna Doddala on 18/12/13.
//  Copyright (c) 2013 Pradyumna Doddala. All rights reserved.
//

#import "CountryListDataSource.h"

#define kCountriesFileName @"countries.json"

@interface CountryListDataSource () {
    
    NSMutableArray *mutableCountryList;
}

@end

@implementation CountryListDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self parseJSON];
    }
    
    return self;
}

- (void)parseJSON
{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountriesArrayEnglish" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    
    mutableCountryList = [[NSMutableArray alloc]init];
    
    
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    
    for(NSArray *singleCountryDictionary in parsedObject)
    {
        Country *singleCountry = [[Country alloc] init];
        singleCountry.countryName = singleCountryDictionary[0];
        singleCountry.countryISO2Code = singleCountryDictionary[1];
        singleCountry.countryPhoneCode = singleCountryDictionary[2];
         
        [mutableCountryList addObject:singleCountry];
    }
    
}

- (NSArray *)countries
{
    return mutableCountryList;
}
@end

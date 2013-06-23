//
//  UIAutocompleteTextField.m
//  Autocomplete TextField
//
//  Created by Alessio Cuccovillo on 23/06/13.
//  Copyright (c) 2013 alessio cuccovillo. All rights reserved.
//

#import "ACHintTextField.h"

@interface ACHintTextField()

@property (weak,nonatomic) NSArray *hints; //hold the possible values based on user input
@property (strong, nonatomic)UITableView *autocompleteTableView; //show the hists array

@end

@implementation ACHintTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareACHintTextField];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self prepareACHintTextField];
    }
    return self;
}

- (void)prepareACHintTextField{
    self.values = [[NSArray alloc] init];
    self.delegate = self;
}

#pragma mark - filterAllPossibleValues
- (BOOL)searchAutocompleteEntriesWithSubstring:(NSString *)substring{
    BOOL result=NO;
    //make the filter
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"SELF like[c] %@",
                              [substring stringByAppendingString:@"*"]];
    
    //create new array filtering the original one
    self.hints = [self.values filteredArrayUsingPredicate:predicate];
    
    //if the filtered array is not empty
    if(self.hints.count>0){
        result=YES;
    }
    
    return result;
}

#pragma mark - textFieldCustomMethods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //close the keyboard
    [self resignFirstResponder];
    
    //the tableView is not longer required
    _autocompleteTableView.hidden=YES; //hide the tableView
    _autocompleteTableView=nil; //free memory
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //execute this ONLY if the user has set the values array
    if(_values && _values.count>0){
        //if the tableView does not exist
        if(!_autocompleteTableView){
            //make the tableView
            CGRect rect=CGRectMake(textField.frame.origin.x,
                                   textField.frame.origin.y + textField.frame.size.height,
                                   textField.frame.size.width + 50,
                                   120); //size and position
            _autocompleteTableView=[[UITableView alloc] initWithFrame:rect]; //alloc & init
            _autocompleteTableView.delegate=self; //delegate to work with the cells
            _autocompleteTableView.dataSource=self; //delegate for the datasource
            _autocompleteTableView.scrollEnabled = YES; //the user can scroll?
            _autocompleteTableView.hidden = YES; //do not show the tableView, yet.
            [self.superview addSubview:_autocompleteTableView]; //add to the main view
        }
        
        //read the textField text
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        
        if (substring.length>0 && [self searchAutocompleteEntriesWithSubstring:substring]) {
            _autocompleteTableView.hidden = NO; //show the tableView
            [_autocompleteTableView reloadData]; //inform the tableView that the dataSource has changed
        }else{
            _autocompleteTableView.hidden=YES; //hide the tableView
            _autocompleteTableView=nil; //free memory
        }
    }
    return YES;
}

#pragma mark - tableViewCustomMethods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //when the user tap the cell we writ the cell's value in the textField and hide the tableView
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.text = selectedCell.textLabel.text;
    tableView.hidden=YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.hints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text=self.hints[indexPath.item];
    
    return cell;
}

@end

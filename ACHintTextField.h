//
//  UIAutocompleteTextField.h
//  Autocomplete TextField
//
//  Created by Alessio Cuccovillo on 23/06/13.
//  Copyright (c) 2013 alessio cuccovillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACHintTextField : UITextField<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    
}
//public properties
@property (strong, nonatomic) NSArray *values;


@end

//
//  UIViewController+SearchBar.h
//  k12
//
//  Created by Yaming on 3/16/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface UIViewController(SearchBar)<UISearchBarDelegate>

@property UISearchBar* searchBar;
@property UIButton* searchOverlayButton;

-(void)doFilterOnSearch:(NSString*)keyword;
-(void)hideSearchKeybard;

@end

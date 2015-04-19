//
//  UIViewController+SearchBar.m
//  k12
//
//  Created by Yaming on 3/16/15.
//  Copyright (c) 2015 jiaxiaobang.com. All rights reserved.
//

#import "UIViewController+SearchBar.h"

@implementation UIViewController(SearchBar)

ADD_DYNAMIC_PROPERTY(UISearchBar*, searchBar, setSearchBar);
ADD_DYNAMIC_PROPERTY(UIButton*, searchOverlayButton, setSearchOverlayButton);

-(void)hideSearchKeybard{
    [self hideKeyboard:self.searchOverlayButton];
}

#pragma mark - UISearchbar

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    if (searchText.length == 0) {
        [self doFilterOnSearch:searchText];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // add the button to the main view
    self.searchOverlayButton = [[UIButton alloc] initWithFrame:self.view.frame];
    // set the background to black and have some transparency
    self.searchOverlayButton.backgroundColor = [UIColor clearColor];
    self.searchOverlayButton.tag = 10001;
    // add an event listener to the button
    [self.searchOverlayButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    // add to main view
    [self.view addSubview:self.searchOverlayButton];
}

- (void)hideKeyboard:(UIButton *)sender
{
    // hide the keyboard
    [self.searchBar resignFirstResponder];
    // remove the overlay button
    [sender removeFromSuperview];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBarRef{
    NSString* keyword = searchBarRef.text;
    [self doFilterOnSearch:keyword];
}

-(void)doFilterOnSearch:(NSString*)keyword{
    if ([self respondsToSelector:@selector(filterBySearchBar:)]) {
        [self performSelector:@selector(filterBySearchBar:) withObject:keyword];
    }
}

- (void)filterBySearchBar:(NSString*)keyword {
    // do nothing
}

@end

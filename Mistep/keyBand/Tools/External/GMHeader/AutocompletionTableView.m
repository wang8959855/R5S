//
//  CMTableView.m
//  ZhanghaoBuquan
//
//  Created by 迈诺科技 on 16/4/26.
//  Copyright © 2016年 huichenghe. All rights reserved.
//

#import "AutocompletionTableView.h"

#define TABLEVIEW_MAX_HEIGHT    120

@interface AutocompletionTableView ()
@property (nonatomic, strong) NSArray *suggestionOptions; // of selected NSStrings
@property (nonatomic, strong) UITextField *textField; // will set automatically as user enters text
@property (nonatomic, strong) UIFont *cellLabelFont; // will copy style from assigned textfield

- (void) resizingTableHeight;

@end

@implementation AutocompletionTableView

@synthesize suggestionsDictionary = _suggestionsDictionary;
@synthesize suggestionOptions = _suggestionOptions;
@synthesize textField = _textField;
@synthesize cellLabelFont = _cellLabelFont;
@synthesize options = _options;
@synthesize tabDelegate = _tabDelegate;

#pragma mark - Initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options
{
    //set the options first
    self.options = options;
    CGRect frame;
    // frame must align to the textfield
    frame = CGRectMake(textField.frame.origin.x,
                       textField.frame.origin.y + textField.frame.size.height,
                       textField.frame.size.width,
                       TABLEVIEW_MAX_HEIGHT);
    
    
    
    // save the font info to reuse in cells
    self.cellLabelFont = textField.font;
    
    self = [super initWithFrame:frame
                          style:UITableViewStylePlain];
    
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    
    // turn off standard correction
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // to get rid of "extra empty cell" on the bottom
    // when there's only one cell in the table
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:v];
    self.hidden = YES;
    
    //在uiview 下面
    if (textField.superview.superview == nil) {
        [parentViewController.view addSubview:self];
    } else {
        [textField.superview addSubview:self];
    }
    
    self.alpha = 1;
    
    
    [textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(textFieldBeginEdit:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(textFieldEndEdit:) forControlEvents:UIControlEventEditingDidEnd];
    [textField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    return self;
}

- (void) resizingTableHeight {
    NSInteger nCount = self.suggestionOptions.count;
    
    CGRect frame = self.frame;
    
    if (nCount * 44.0 < TABLEVIEW_MAX_HEIGHT) {
        frame.size.height = nCount * 44.0;
    } else {
        frame.size.height = TABLEVIEW_MAX_HEIGHT;
    }
    self.frame = frame;
}

#pragma mark - Logic staff
- (BOOL) substringIsInDictionary:(NSString *)subString
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSRange range;
    
    for (NSString *tmpString in self.suggestionsDictionary)
    {
        range = ([[self.options valueForKey:ACOCaseSensitive] isEqualToNumber:[NSNumber numberWithInt:1]]) ? [tmpString rangeOfString:subString] : [tmpString rangeOfString:subString options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) [tmpArray addObject:tmpString];
    }
    if ([tmpArray count]>0)
    {
        self.suggestionOptions = tmpArray;
        return YES;
    }
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestionOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        UIView *selectBackView = [[UIView alloc] initWithFrame:cell.frame];
        selectBackView.backgroundColor = [UIColor colorWithRed:201.0 / 255.0
                                                         green:201.0 / 255.0
                                                          blue:201.0 / 255.0
                                                         alpha:1];
        cell.selectedBackgroundView = selectBackView;
        
//                UIView *accView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//                button.frame = CGRectMake(0, 0, 30, 30);
//                [accView addSubview:button];
//                cell.accessoryView = accView;
//                [accView release];
//        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:view];
        view.sd_layout.leftEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        .widthIs(0.5);
        UIView *view1 = [[UIView alloc]init];
        view1.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:view1];
        view1.sd_layout.rightEqualToView(cell.contentView)
        .topEqualToView(cell.contentView)
        .bottomEqualToView(cell.contentView)
        .widthIs(0.5);
        
    }
    
    if ([self.options valueForKey:ACOUseSourceFont])
    {
        cell.textLabel.font = [self.options valueForKey:ACOUseSourceFont];
    } else {
        cell.textLabel.font = self.cellLabelFont;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    cell.textLabel.text = [self.suggestionOptions objectAtIndex:indexPath.row];

    cell.textLabel.sd_layout.leftSpaceToView(cell.backgroundView,_leftSpace);
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tabDelegate &&
        [_tabDelegate respondsToSelector:@selector(autoCompletionTableView:didSelectString:)]) {
        [_tabDelegate autoCompletionTableView:self
                              didSelectString:[self.suggestionOptions objectAtIndex:indexPath.row]];
    }
    [self.textField setText:[self.suggestionOptions objectAtIndex:indexPath.row]];
    [self hideOptionsView];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_tabDelegate &&
            [_tabDelegate respondsToSelector:@selector(autoCompletionTableView:deleteString:)]) {
            [_tabDelegate autoCompletionTableView:self deleteString:[self.suggestionOptions objectAtIndex:indexPath.row]];
        }
        
        [self showOptionsView];
        self.suggestionOptions = [NSMutableArray arrayWithArray:_suggestionsDictionary];
        [self reloadData];
    }
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
}

#pragma mark - UITextField delegate
- (void)textFieldValueChanged:(UITextField *)textField
{
    self.textField = textField;
    NSString *curString = textField.text;
    
    if (![curString length])
    {
        [self textFieldBeginEdit:textField];
        return;
    } else if ([self substringIsInDictionary:curString]) {
        [self reloadData];
        [self showOptionsView];
    } else {
        [self hideOptionsView];
    }
}

- (void) textFieldBeginEdit:(UITextField *) textField {
    self.textField = textField;
    if ([textField.text length] == 0) {
        self.suggestionOptions = [NSMutableArray arrayWithArray:_suggestionsDictionary];
        [self reloadData];
        [self showOptionsView];
        
    }
}

- (void) textFieldEndEdit:(UITextView *) textField {
    [self hideOptionsView];
}

- (void) textFieldDidEndOnExit:(UITextField *) textField {
    [self hideOptionsView];
}

#pragma mark - Options view control
- (void)showOptionsView
{
    [self resizingTableHeight];
    self.hidden = NO;
}

- (void) hideOptionsView
{
    self.hidden = YES;
}

@end
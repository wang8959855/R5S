//
//  SMTabBarItemCell.m
//  SMSplitViewController
//
//  Created by Sergey Marchukov on 16.02.14.
//  Copyright (c) 2014 Sergey Marchukov. All rights reserved.
//
//  This content is released under the ( http://opensource.org/licenses/MIT ) MIT License.
//

#import "SMTabBarItemCell.h"

@interface SMTabBarItemCell ()
{
    UIView *_topSeparator;
    UIView *_separator;
    UIView *_viewBackground;
    
}
@end

@implementation SMTabBarItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
//        _iconView.
        [self addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        
        _selectedColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _iconView.frame = CGRectMake(self.bounds.size.width / 2 - 20 / 2, self.bounds.size.height/2 - 20/2, 20, 20);
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 12);
    
    if (_separator)
        _separator.frame = CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
}

#pragma mark -
#pragma mark - Properties

- (void)setImage:(UIImage *)image {
    
    _image = image;
}

- (void)setIsFirstCell:(BOOL)isFirstCell {
    
    _isFirstCell = isFirstCell;
    
    if (isFirstCell) {
        
        _topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
        _topSeparator.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
        [self addSubview:_topSeparator];
    }
}

- (void)setCellType:(SMTabBarItemCellType)cellType {
    
    _cellType = cellType;
    
    if (_cellType == SMTabBarItemCellTab) {
        
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
        [self addSubview:_separator];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    _titleLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
    
    if (_cellType == SMTabBarItemCellTab) {
        
            _viewBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 1)];
            _viewBackground.backgroundColor = highlighted ? _selectedColor : [UIColor clearColor];
            self.backgroundView = _viewBackground;
            if (_isFirstCell) {
                
                _topSeparator.hidden = highlighted ? YES : NO;
            }
        _separator.backgroundColor = highlighted ? _selectedColor:[UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    }
    
    _iconView.image = highlighted ? _selectedImage : _image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _titleLabel.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
    
    if (_cellType == SMTabBarItemCellTab) {
        
        _viewBackground.backgroundColor = selected ? _selectedColor : [UIColor clearColor];
    }
    
    if (_isFirstCell) {
        
        _topSeparator.hidden = selected ? YES : NO;
    }
    
    _iconView.image = selected ? _selectedImage : _image;
}


@end

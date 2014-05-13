//
//  DDMRankingTableViewCell.m
//  iPipe
//
//  Created by Salvador Pamanes on 12/05/14.
//  Copyright (c) 2014 Ivan Diaz. All rights reserved.
//

#import "DDMRankingTableViewCell.h"

@implementation DDMRankingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

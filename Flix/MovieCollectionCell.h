//
//  MovieCollectionCell.h
//  Flix
//
//  Created by Felianne Teng on 6/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *noPosterFoundLabel;

@end

NS_ASSUME_NONNULL_END

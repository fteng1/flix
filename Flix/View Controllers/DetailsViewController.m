//
//  DetailsViewController.m
//  Flix
//
//  Created by Felianne Teng on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];

    self.posterView.image = nil;
    if(![posterURLString isEqual:[NSNull null]])
    {
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [self.posterView setImageWithURL:posterURL];
    }
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    
    self.backdropView.image = nil;
    if(![backdropURLString isEqual:[NSNull null]])
    {
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }
    
    self.titleLabel.text = self.movie[@"title"];
    
    // check if the synopsis exists
    NSString *overview = self.movie[@"overview"];
    if (overview.length != 0) {
        self.synopsisLabel.text = self.movie[@"overview"];
    }
    else {
        self.synopsisLabel.text = @"Synopsis not available.";
    }
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    [self.posterView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.posterView.layer setBorderWidth:1.0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

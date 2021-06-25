//
//  FavoritesViewController.m
//  Flix
//
//  Created by Felianne Teng on 6/24/21.
//

#import "FavoritesViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *favoritesView;
@property (weak, nonatomic) IBOutlet UISearchBar *favMovieSearchBar;
@property (nonatomic, strong) NSArray *filteredData;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.favoritesView.dataSource = self;
    self.favoritesView.delegate = self;
    self.favMovieSearchBar.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *saved = [defaults objectForKey:@"savedMovies"];
    self.movies = saved;
    self.filteredData = saved;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.favoritesView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    // number of posters per line depends on device size
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = (self.favoritesView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.favoritesView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    // refresh page when it is accessed
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *saved = [defaults objectForKey:@"savedMovies"];
    self.movies = saved;
    [self searchBar:self.favMovieSearchBar textDidChange:self.favMovieSearchBar.text];
    [self.favoritesView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // searches in saved movies only
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [((NSString *) (evaluatedObject[@"title"])).uppercaseString containsString:searchText.uppercaseString];
        }];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.favoritesView reloadData];
 
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.favoritesView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredData[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    
    cell.posterView.image = nil;
    
    // check if URL to poster image is null
    if(![posterURLString isEqual:[NSNull null]])
    {
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        [cell.posterView setImageWithURL:posterURL];
        cell.noPosterFoundLabel.text = @"";
    }
    else {
        cell.noPosterFoundLabel.text = movie[@"title"];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}


@end

//
//  FilterViewController.m
//  FenzoFilters
//
//  Created by yangyang on 15/3/4.
//  Copyright (c) 2015年 Fengzo. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterCollectionViewCell.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define kFilterCollectionViewCellReuseIdentifier @"FilterCollectionViewCell"

@interface FilterViewController ()

@property (nonatomic, strong) NSArray* filtersAry;
@property (nonatomic, strong) NSMutableDictionary* filtersImageDict;

@property (nonatomic, strong) UIImage* normalImage;
@property (nonatomic, strong) UIImage* submitImage;
@property (nonatomic, strong) UIImageView* previewImageView;
@property (nonatomic, strong) UICollectionView* filterCollectionView;
@property (nonatomic, strong) UIView* topDividingLine;
@property (nonatomic, strong) UILabel* filterTitleLbl;
@property (nonatomic, strong) UIView* bottomDividingLine;
@property (nonatomic, strong) UIButton* backBtn;
@property (nonatomic, strong) UIButton* submitBtn;
@property (nonatomic, strong) FilterFinishBlk submitBlk;

@end


@implementation FilterViewController

#pragma mark - Methods

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)submit
{
    NSLog(@"submit");
    
    _submitBlk(_submitImage);
    [self back];
}

- (void)setUpImage:(UIImage*)image callback:(FilterFinishBlk)callback
{
    self.normalImage = image;
    self.submitImage = image;
    self.filtersImageDict = [NSMutableDictionary new];
    
    [_previewImageView setImage:image];
    
    self.submitBlk = callback;
}

- (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName
{
    if([filterName isEqualToString:@"CLDefaultEmptyFilter"]){
        return image;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    if([filterName isEqualToString:@"CIVignetteEffect"]){
        // parameters for CIVignetteEffect
        CGFloat R = MIN(image.size.width, image.size.height)*image.scale/2;
        CIVector *vct = [[CIVector alloc] initWithX:image.size.width*image.scale/2 Y:image.size.height*image.scale/2];
        [filter setValue:vct forKey:@"inputCenter"];
        [filter setValue:[NSNumber numberWithFloat:0.9] forKey:@"inputIntensity"];
        [filter setValue:[NSNumber numberWithFloat:R] forKey:@"inputRadius"];
    }
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(NO)}];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return result;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)initUI
{
    [self.view setBackgroundColor:RGBACOLOR(12, 15, 20, 1)];
    
    self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-230)];
    [_previewImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _previewImageView.frame.size.height, self.view.frame.size.width, 150) collectionViewLayout:layout];
    _filterCollectionView.dataSource = self;
    _filterCollectionView.delegate = self;
    [_filterCollectionView registerClass:[FilterCollectionViewCell class] forCellWithReuseIdentifier:kFilterCollectionViewCellReuseIdentifier];

    self.topDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0, _previewImageView.frame.size.height+_filterCollectionView.frame.size.height+1, self.view.frame.size.width, 0.5f)];
    [_topDividingLine setBackgroundColor:RGBACOLOR(14, 39, 36, 1)];
    self.filterTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _topDividingLine.frame.origin.y+1, self.view.frame.size.width, 38)];
    [_filterTitleLbl setBackgroundColor:[UIColor clearColor]];
    [_filterTitleLbl setText:@"滤镜"];
    [_filterTitleLbl setFont:[UIFont systemFontOfSize:14.0f]];
    [_filterTitleLbl setTextAlignment:NSTextAlignmentCenter];
    [_filterTitleLbl setTextColor:RGBACOLOR(56, 204, 174, 1)];
    self.bottomDividingLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-41, self.view.frame.size.width, 0.5f)];
    [_bottomDividingLine setBackgroundColor:RGBACOLOR(14, 39, 36, 1)];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setTitle:@"上一步" forState:UIControlStateNormal];
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    [_backBtn setFrame:CGRectMake(0, self.view.frame.size.height-40, 120, 40)];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_submitBtn setBackgroundColor:[UIColor clearColor]];
    [_submitBtn setFrame:CGRectMake(self.view.frame.size.width-120, self.view.frame.size.height-40, 120, 40)];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_previewImageView];
    [self.view addSubview:_filterCollectionView];
    [self.view addSubview:_topDividingLine];
    [self.view addSubview:_filterTitleLbl];
    [self.view addSubview:_bottomDividingLine];
    [self.view addSubview:_backBtn];
    [self.view addSubview:_submitBtn];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filtersAry = @[@"CLDefaultEmptyFilter",@"CIVignetteEffect",@"CIPhotoEffectInstant",@"CIPhotoEffectProcess",@"CIPhotoEffectTransfer",@"CISRGBToneCurveToLinear",@"CISepiaTone",@"CIPhotoEffectChrome",@"CIPhotoEffectFade",@"CILinearToSRGBToneCurve",@"CIPhotoEffectTonal",@"CIPhotoEffectNoir",@"CIPhotoEffectMono",@"CIColorInvert"];
        
        [self initUI];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_filtersAry count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFilterCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.clipsToBounds = YES;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = RGBACOLOR(56, 204, 174, 1).CGColor;
    if (indexPath.row==0) {
        cell.layer.borderWidth = 2.0f;
    } else {
        cell.layer.borderWidth = 0.0f;
    }
    
    if (_filtersImageDict[_filtersAry[indexPath.row]]) {
        [cell.imageView setImage:_filtersImageDict[_filtersAry[indexPath.row]]];
    } else {
        [cell.imageView setImage:_normalImage];
        
        __block UIImageView* blkImageView = cell.imageView;
//        __block UIImage* blkNormalImage = [self imageWithImage:_normalImage scaledToSize:CGSizeMake(_normalImage.size.width/10, _normalImage.size.height/10)];
        __block UIImage* blkNormalImage = _normalImage;
        __block NSArray* blkFiltersAry = _filtersAry;
        __block NSDictionary* blkFiltersImageDict = _filtersImageDict;
        __block NSInteger blkRowNum = indexPath.row;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block UIImage* filterdImage = [self filteredImage:blkNormalImage withFilterName:blkFiltersAry[blkRowNum]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [blkImageView setImage:filterdImage];
                [blkFiltersImageDict setValue:filterdImage forKey:blkFiltersAry[blkRowNum]];
            });
        });
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(103,103);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped %@",_filtersAry[indexPath.row]);
    FilterCollectionViewCell* cell = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2.0f;
    
    if (indexPath.row!=0) {
        FilterCollectionViewCell* cell0 = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell0.layer.borderWidth = 0.0f;
        NSLog(@"Clean row 0 color");
    }
    
    __block UIImageView* blkPreviewImageView = _previewImageView;
    __block UIImage* blkNormalImage = _normalImage;
    __block UIImage* blkSubmitImage = _submitImage;
    __block NSArray* blkFiltersAry = _filtersAry;
    __block NSInteger blkRowNum = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block UIImage* filterdImage = [self filteredImage:blkNormalImage withFilterName:blkFiltersAry[blkRowNum]];
        blkSubmitImage = filterdImage;
        dispatch_async(dispatch_get_main_queue(), ^{
            [blkPreviewImageView setImage:filterdImage];
        });
    });
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell* cell = (FilterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0.0f;
}

@end

//
//  OCAGeometry+Sizes.m
//  Objective-Chain
//
//  Created by Martin Kiss on 13.1.14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import "OCAGeometry+Sizes.h"
#import "OCAMath.h"










@implementation OCAGeometry (Sizes)





#pragma mark -
#pragma mark Predicates
#pragma mark -


+ (NSPredicate *)predicateForSize:(BOOL(^)(CGSize size))block {
    return [OCAPredicate predicateForClass:[NSValue class] block:^BOOL(NSValue *value) {
        CGSize size = OCAUnboxSize(value);
        return block(size);
    }];
}


+ (NSPredicate *)isSizeEqualTo:(CGSize)otherSize {
    return [OCAGeometry predicateForSize:^BOOL(CGSize size) {
        return CGSizeEqualToSize(size, otherSize);
    }];
}


+ (NSPredicate *)isSizeZero {
    return [OCAGeometry predicateForSize:^BOOL(CGSize size) {
        return CGSizeEqualToSize(size, CGSizeZero);
    }];
}





#pragma mark -
#pragma mark Transformers
#pragma mark -


#pragma mark Creating Sizes


+ (OCATransformer *)sizeFromString {
    return [[OCATransformer fromClass:[NSString class] toClass:[NSValue class]
                            transform:^NSValue *(NSString *input) {
                                
                                return OCABox(OCASizeFromString(input));
                                
                            } reverse:^NSString *(NSValue *input) {
                                
                                return OCAStringFromSize(OCAUnboxSize(input));
                            }]
            describe:@"size from string"
            reverse:@"string from size"];
}


+ (OCATransformer *)makeSizeWithWidth:(CGFloat)width {
    return [[OCATransformer fromClass:[NSNumber class] toClass:[NSValue class]
                            transform:^NSValue *(NSNumber *input) {
                                
                                return OCABox(CGSizeMake(width, input.doubleValue));
                                
                            } reverse:^NSNumber *(NSValue *input) {
                                
                                CGSize size = OCAUnboxSize(input);
                                return @(size.height);
                            }]
            describe:[NSString stringWithFormat:@"point with width %@", @(width)]
            reverse:@"CGSize.height"];
}


+ (OCATransformer *)makeSizeWithHeight:(CGFloat)height {
    return [[OCATransformer fromClass:[NSNumber class] toClass:[NSValue class]
                            transform:^NSValue *(NSNumber *input) {
                                
                                return OCABox(CGSizeMake(input.doubleValue, height));
                                
                            } reverse:^NSNumber *(NSValue *input) {
                                
                                CGSize size = OCAUnboxSize(input);
                                return @(size.width);
                            }]
            describe:[NSString stringWithFormat:@"point with height %@", @(height)]
            reverse:@"CGSize.width"];
}





#pragma mark Modifying Sizes


+ (OCATransformer *)modifySize:(CGSize(^)(CGSize size))block {
    return [[OCATransformer fromClass:[NSValue class] toClass:[NSValue class]
                            asymetric:^NSValue *(NSValue *input) {
                                
                                CGSize size = OCAUnboxSize(input);
                                size = block(size);
                                return OCABox(size);
                            }]
            describe:@"modify size"];
}


+ (OCATransformer *)modifySize:(CGSize(^)(CGSize size))block reverse:(CGSize(^)(CGSize size))reverseBlock {
    return [[OCATransformer fromClass:[NSValue class] toClass:[NSValue class]
                            transform:^NSValue *(NSValue *input) {
                                
                                CGSize size = OCAUnboxSize(input);
                                size = block(size);
                                return OCABox(size);
                                
                            } reverse:^NSValue *(NSValue *input) {
                                
                                CGSize size = OCAUnboxSize(input);
                                size = reverseBlock(size);
                                return OCABox(size);
                            }]
            describe:@"modify size"];
}


+ (OCATransformer *)extendSizeBy:(CGSize)otherSize {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeExtendBySize(size, otherSize);
        
    } reverse:^CGSize(CGSize size) {
        
        return OCASizeShrinkBySize(size, otherSize);
    }]
            describe:[NSString stringWithFormat:@"extend size by %@", OCAStringFromSize(otherSize)]
            reverse:[NSString stringWithFormat:@"shrink size by %@", OCAStringFromSize(otherSize)]];
}


+ (OCATransformer *)shrinkSizeBy:(CGSize)otherSize {
    return [[OCAGeometry extendSizeBy:otherSize] reversed];
}


+ (OCATransformer *)multiplySizeBy:(CGFloat)multiplier {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeMultiply(size, multiplier);
        
    } reverse:^CGSize(CGSize size) {
        
        return OCASizeMultiply(size, 1 / multiplier);
    }]
            describe:[NSString stringWithFormat:@"multiply size by %@", @(multiplier)]
            reverse:[NSString stringWithFormat:@"multiply size by %@", @(1 / multiplier)]];
}


+ (OCATransformer *)transformSize:(CGAffineTransform)affineTransform {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return CGSizeApplyAffineTransform(size, affineTransform);
        
    } reverse:^CGSize(CGSize size) {
        
        return CGSizeApplyAffineTransform(size, CGAffineTransformInvert(affineTransform));
    }]
            describe:@"apply affine transform on size"];
}


+ (OCATransformer *)roundSizeTo:(CGFloat)scale {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeRound(size, scale);
        
    } reverse:^CGSize(CGSize size) {
        return size;
    }]
            describe:[NSString stringWithFormat:@"round size to %@", @(scale)]
            reverse:@"pass"];
}


+ (OCATransformer *)floorSizeTo:(CGFloat)scale {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeFloor(size, scale);
        
    } reverse:^CGSize(CGSize size) {
        return size;
    }]
            describe:[NSString stringWithFormat:@"floor size to %@", @(scale)]
            reverse:@"pass"];
}


+ (OCATransformer *)ceilSizeTo:(CGFloat)scale {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeCeil(size, scale);
        
    } reverse:^CGSize(CGSize size) {
        return size;
    }]
            describe:[NSString stringWithFormat:@"ceil size to %@", @(scale)]
            reverse:@"pass"];
}


+ (OCATransformer *)standardizeSize {
    return [[OCAGeometry modifySize:^CGSize(CGSize size) {
        
        return OCASizeStandardize(size);
        
    } reverse:^CGSize(CGSize size) {
        
        return size;
    }]
            describe:@"standardize size"
            reverse:@"pass"];
}





#pragma mark Disposing Sizes


+ (OCATransformer *)stringFromSize {
    return [[OCAGeometry sizeFromString] reversed];
}


+ (OCATransformer *)sizeArea {
    return [[OCATransformer fromClass:[NSValue class] toClass:[NSNumber class]
                           asymetric:^NSNumber *(NSValue *input) {
                               
                               CGSize size = OCAUnbox(input, CGSize, CGSizeZero);
                               return @( OCASizeGetArea(size) );
                           }]
            describe:@"area of size"];
}


+ (OCATransformer *)sizeRatio {
    return [[OCATransformer fromClass:[NSValue class] toClass:[NSNumber class]
                            asymetric:^NSNumber *(NSValue *input) {
                                
                                CGSize size = OCAUnbox(input, CGSize, CGSizeZero);
                                return @( OCASizeGetRatio(size) );
                            }]
            describe:@"ratio of size"];
}





@end










#pragma mark -
#pragma mark Functions
#pragma mark -


CGSize OCASizeFromString(NSString *string) {
#if OCA_iOS
    return CGSizeFromString(string);
#else
    return NSSizeToCGSize(NSSizeFromString(string));
#endif
}


NSString * OCAStringFromSize(CGSize size) {
#if OCA_iOS
    return NSStringFromCGSize(size);
#else
    return NSStringFromSize(NSSizeFromCGSize(size));
#endif
}


CGSize OCASizeExtendBySize(CGSize a, CGSize b) {
    a.width += b.width;
    a.height += b.height;
    return a;
}


CGSize OCASizeShrinkBySize(CGSize a, CGSize b) {
    a.width -= b.width;
    a.height -= b.height;
    return a;
}


CGSize OCASizeMultiply(CGSize s, CGFloat m) {
    s.width *= m;
    s.height *= m;
    return s;
}


CGSize OCASizeRound(CGSize size, CGFloat scale) {
    size.width = OCARound(size.width, scale);
    size.height = OCARound(size.height, scale);
    return size;
}


CGSize OCASizeFloor(CGSize size, CGFloat scale) {
    size.width = OCAFloor(size.width, scale);
    size.height = OCAFloor(size.height, scale);
    return size;
}


CGSize OCASizeCeil(CGSize size, CGFloat scale) {
    size.width = OCACeil(size.width, scale);
    size.height = OCACeil(size.height, scale);
    return size;
}


CGSize OCASizeStandardize(CGSize size) {
    size.width = ABS(size.width);
    size.height = ABS(size.height);
    return size;
}


CGFloat OCASizeGetArea(CGSize size) {
    return (size.width * size.height);
}


CGFloat OCASizeGetRatio(CGSize size) {
    return (size.width / size.height);
}



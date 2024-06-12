#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "MoviePoster" asset catalog image resource.
static NSString * const ACImageNameMoviePoster AC_SWIFT_PRIVATE = @"MoviePoster";

/// The "Netflix Long" asset catalog image resource.
static NSString * const ACImageNameNetflixLong AC_SWIFT_PRIVATE = @"Netflix Long";

/// The "kingkong" asset catalog image resource.
static NSString * const ACImageNameKingkong AC_SWIFT_PRIVATE = @"kingkong";

/// The "legend" asset catalog image resource.
static NSString * const ACImageNameLegend AC_SWIFT_PRIVATE = @"legend";

/// The "netflix" asset catalog image resource.
static NSString * const ACImageNameNetflix AC_SWIFT_PRIVATE = @"netflix";

/// The "truman" asset catalog image resource.
static NSString * const ACImageNameTruman AC_SWIFT_PRIVATE = @"truman";

#undef AC_SWIFT_PRIVATE

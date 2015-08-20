//
//  MediaStep+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "MediaStep.h"


@interface MediaStep (Human)

@property (nonatomic, strong) NSData* video;
@property (nonatomic, strong) NSData* image;

/*enum StepMediaType {
    StepMediaTypeImage = 0,
    StepMediaTypeVideo = 1
};*/

+(MediaStep*)createMediaStepInMOC:(NSManagedObjectContext*)moc;
-(MediaStep*)copy;

//-(BOOL)isImage;
//-(BOOL)isVideo;

-(UIImage*)image;
-(NSData*)video;

-(UIImage*)thumbnailImage;
-(NSString*)title;
@end

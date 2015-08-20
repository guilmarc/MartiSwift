//
//  Media+Human.h
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Media.h"

@interface Media (Human)



enum MediaType {
    MediaTypeImage = 0,
    MediaTypeVideo = 1,
    MediaTypePicto = 2
};

@property (nonatomic) enum MediaType contentType;

+(Media*)createMediaOfType:(enum MediaType)mediaType withData:(NSData*)data inMOC:(NSManagedObjectContext*)moc;

//+(Media*)createImageMediaWithData:(NSData*)data inMOC:(NSManagedObjectContext*)moc;
//+(Media*)createVideoMediaWithData:(NSData*)data inMOC:(NSManagedObjectContext*)moc;

-(Media*)copy;

-(BOOL)isImage;
-(BOOL)isVideo;
-(BOOL)isPicto;



@end

//
//  Media+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "Media+Human.h"

@implementation Media (Human)

@dynamic contentType;


+(Media*)createMediaOfType:(enum MediaType)mediaType withData:(NSData*)data inMOC:(NSManagedObjectContext*)moc{

    Media* newMedia = [NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:moc];
    newMedia.data = data;
    newMedia.type = [NSNumber numberWithInt:mediaType];
    return newMedia;
}


/*+(Media*)createImageMediaWithData:(NSData*)data inMOC:(NSManagedObjectContext*)moc{
    
    Media* newMedia = [NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:moc];
    newMedia.data = data;
    newMedia.type = [NSNumber numberWithInt:MediaTypeImage];
    return newMedia;
    
}

+(Media*)createVideoMediaWithData:(NSData*)data inMOC:(NSManagedObjectContext*)moc{
    Media* newMedia = [NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:moc];
    newMedia.data = data;
    newMedia.type = [NSNumber numberWithInt:MediaTypeVideo];
    return newMedia;
}*/

-(BOOL)isImage { return [self.type intValue] == MediaTypeImage; }
-(BOOL)isVideo { return [self.type intValue] == MediaTypeVideo; }
-(BOOL)isPicto { return [self.type intValue] == MediaTypePicto; }


-(void)setContentType:(enum MediaType)type{
    self.type = [NSNumber numberWithInt:type];
}

-(enum MediaType)contentType{
    return [self.type intValue];
}

-(Media*)copy{
    Media *newMedia = [NSEntityDescription insertNewObjectForEntityForName:@"Media" inManagedObjectContext:self.managedObjectContext];
    newMedia.type = self.type;
    newMedia.data = self.data;
    
    return newMedia;
}

@end

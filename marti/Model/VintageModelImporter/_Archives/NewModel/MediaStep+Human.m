//
//  MediaStep+Human.m
//  marti
//
//  Created by Marco Guilmette on 2/18/2014.
//
//

#import "MediaStep+Human.h"
#import "Media+Human.h"

@implementation MediaStep (Human)

@dynamic image, video;

+(MediaStep*)createMediaStepInMOC:(NSManagedObjectContext*)moc{

    MediaStep *newMediaStep = [NSEntityDescription insertNewObjectForEntityForName:@"MediaStep" inManagedObjectContext:moc];
    
    //TODO : Add an Image MEDIA WITH PLACEHOLDER
    newMediaStep.mediaAssistant = [Media createMediaOfType:MediaTypeImage withData:nil inMOC:moc];
    
    return newMediaStep;
}

-(MediaStep*)copy{
    MediaStep *newMediaStep = [NSEntityDescription insertNewObjectForEntityForName:@"MediaStep" inManagedObjectContext:self.managedObjectContext];
    newMediaStep.active = self.active;
    newMediaStep.audioAssistant = self.audioAssistant;
    newMediaStep.duration = self.duration;
    newMediaStep.index = self.index;
    newMediaStep.name = self.name;
    newMediaStep.textualAssistant = self.textualAssistant;
    newMediaStep.thumbnail = self.thumbnail;
    newMediaStep.type = self.type;
    
    if (self.mediaAssistant != nil ) {
        newMediaStep.mediaAssistant =  [self.mediaAssistant copy];
    }
    
    return newMediaStep;
}

-(BOOL)isMediaStep {return true;}
-(BOOL)isRoutingStep {return false;}
-(BOOL)isSelectionStep {return false;}


//-(BOOL)isImage {return [self.mediaType intValue] ==  StepMediaTypeImage;}
//-(BOOL)isVideo {return [self.mediaType intValue] ==  StepMediaTypeVideo;}


-(UIImage*)image {

    if( self.mediaAssistant == nil) { return [UIImage imageNamed:@"mediaStepPlaceholder"]; }
    
    if( [self.mediaAssistant.type intValue] !=  MediaTypeImage) { return [UIImage imageNamed:@"mediaStepPlaceholder"]; }
    
    return [UIImage imageWithData:self.mediaAssistant.data];

}

-(void)setImage:(NSData *)image{
    if( self.mediaAssistant == nil ) { //Create the record here
    }
    
    self.mediaAssistant.type = [NSNumber numberWithInt:MediaTypeImage];
    self.mediaAssistant.data = image;
    
}

-(NSData*)video{
    if( self.mediaAssistant == nil) { return nil; }
    
    if( [self.mediaAssistant.type intValue] !=  MediaTypeVideo) { return nil; }
    
    return self.mediaAssistant.data;
}

-(void)setVideo:(NSData *)video{
    if( self.mediaAssistant == nil ) { //Create the record here
    }
    
    self.mediaAssistant.type = [NSNumber numberWithInt:MediaTypeVideo];
    self.mediaAssistant.data = video;

}


-(UIImage*)thumbnailImage{
    if( self.thumbnail != nil ) {
        return [UIImage imageWithData:self.thumbnail];
    } else {
        return [UIImage imageNamed:@"mediaStepPlaceholder"];
    }
}

-(NSString*)title{
    if( self.name.length > 0 ) {
        return self.name;
    } else {
        return NSLocalizedString(@"DummyTitleSimpleStepKey", @"");
    }
}

@end

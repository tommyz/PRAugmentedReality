//
//  ARViewController.h
//  PRAR-Simple
//
//  Created by tommy su on 2017/6/16.
//  Copyright © 2017年 GeoffroyLesage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRARManager.h"

@interface ARViewController : UIViewController <PRARManagerDelegate>
{
    
}
@property (nonatomic, strong) NSMutableArray *arData;
@property (nonatomic, strong) CLLocation *userLoaction;
@end

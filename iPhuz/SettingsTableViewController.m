//
//  SettingsTableViewController.m
//  iPhuz
//
//  Created by Jack on 11/19/14.
//  Copyright (c) 2014 JackCable. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (strong, nonatomic) IBOutlet UILabel *playToLabel;
@property (strong, nonatomic) IBOutlet UISwitch *timedMatchSwitch;
@property (strong, nonatomic) IBOutlet UIStepper *timedMatchStepper;
@property (strong, nonatomic) IBOutlet UILabel *timedMatchLabel;
@property (strong, nonatomic) IBOutlet UIStepper *playToStepper;

@end

@implementation SettingsTableViewController {
    NSUserDefaults *defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) updateView {
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isTimedMatch = [defaults boolForKey:@"TimedMatch"];
    
    _timedMatchSwitch.on = isTimedMatch;
    
    [self setTimedMatch:isTimedMatch];
    
    int playTo = [[defaults objectForKey:@"PlayTo"] intValue];
    _playToLabel.text = [NSString stringWithFormat:@"%i", playTo];
    _playToStepper.minimumValue = 1;
    _playToStepper.maximumValue = 100;
    _playToStepper.value = playTo;
    
    int matchLength = [[defaults objectForKey:@"MatchLength"] intValue];
    _timedMatchLabel.text = [NSString stringWithFormat:@"%i:00", matchLength];
    _timedMatchStepper.minimumValue = 1;
    _timedMatchStepper.maximumValue = 120;
    _timedMatchStepper.value = matchLength;
}

-(void) setTimedMatch: (BOOL) isTimedMatch {
    float disabled = .3;
    if(isTimedMatch) {
        _timedMatchLabel.alpha = 1;
        _timedMatchStepper.userInteractionEnabled = YES;
        _timedMatchStepper.alpha = 1;
        _playToLabel.alpha = disabled;
        _playToStepper.alpha = disabled;
        _playToStepper.userInteractionEnabled = NO;
    } else {
        _timedMatchLabel.alpha = disabled;
        _timedMatchStepper.userInteractionEnabled = NO;
        _timedMatchStepper.alpha = disabled;
        _playToLabel.alpha = 1;
        _playToStepper.alpha = 1;
        _playToStepper.userInteractionEnabled = YES;
    }
}

- (IBAction)playToStepperChanged:(UIStepper *)sender {
    _playToLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    _timedMatchLabel.text = [NSString stringWithFormat:@"%.0f:00", sender.value];
}

- (IBAction)saveButton:(id)sender {
    [defaults setBool:_timedMatchSwitch.on forKey:@"TimedMatch"];
    [defaults setObject:[NSNumber numberWithInt:_playToStepper.value] forKey:@"PlayTo"];
    [defaults setObject:[NSNumber numberWithInt:_timedMatchStepper.value] forKey:@"MatchLength"];
    [defaults synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)timedMatchValueChanged:(id)sender {
    [self setTimedMatch:_timedMatchSwitch.on];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

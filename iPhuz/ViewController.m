//
//  ViewController.m
//  iPhuz
//
//  Created by Jack on 11/19/14.
//  Copyright (c) 2014 JackCable. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *blueScore;
@property (strong, nonatomic) IBOutlet UILabel *greenScore;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *teamWinsLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;

@end

@implementation ViewController {
    NSMutableArray *scores;
    
    int BLUE;
    int GREEN;
    
    NSUserDefaults *defaults;
    
    int secondsRemaining;
    BOOL isPaused;
}

-(void) viewDidAppear:(BOOL)animated {
    
    [self updateDefaults];
    
    [self useDefaults];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BLUE = 0;
    GREEN = 1;
    
    scores = [NSMutableArray arrayWithArray: @[@0, @0]];
    
    _teamWinsLabel.hidden = YES;
    _timeLabel.hidden = YES;
    _startButton.hidden = YES;
    _pauseButton.hidden = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) updateDefaults {
    defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"PlayTo"] == nil) {
        [defaults setObject:@10 forKey:@"PlayTo"];
    }
    if([defaults objectForKey:@"TimedMatch"] == nil) {
        [defaults setBool:false forKey:@"TimedMatch"];
    }
    if([defaults objectForKey:@"MatchLength"] == nil) {
        [defaults setObject:@5 forKey:@"MatchLength"];
    }
    
}

-(void) useDefaults {
    
    BOOL isTimedMatch = [defaults boolForKey:@"TimedMatch"];
    
    _statusLabel.text = [NSString stringWithFormat:@"%@: %@", isTimedMatch ? @"Timed match" : @"Play to", isTimedMatch ? [NSString stringWithFormat:@"%i:00", [[defaults objectForKey:@"MatchLength"] intValue]] : [defaults objectForKey:@"PlayTo"]];
    
    if(isTimedMatch) {
        _startButton.hidden = NO;
        _timeLabel.text = [NSString stringWithFormat:@"%i:00", [self matchLength]];
    } else {
        _startButton.hidden = YES;
        _timeLabel.hidden = YES;
        _pauseButton.hidden = YES;
    }
    
    secondsRemaining = 60*[self matchLength];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) animateLabel : (UILabel *) label {
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // moves label up 100 units in the y axis
                         label.transform = CGAffineTransformMakeTranslation(0, -30);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:.2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              // move label back down to its original position
                                              label.transform = CGAffineTransformMakeTranslation(0,0);
                                          }
                                          completion:nil];
                     }];
    
}

- (IBAction)startTimedMatchButton:(id)sender {
    _timeLabel.hidden = NO;
    _startButton.hidden = YES;
    _pauseButton.hidden = NO;
    isPaused = NO;
    [self countSecond];
}

- (IBAction)pauseButton:(id)sender {
    isPaused = YES;
    _startButton.hidden = NO;
    _pauseButton.hidden = YES;
}

-(void) countSecond {
    if(isPaused) return;
    _timeLabel.text = [NSString stringWithFormat:@"%i:%.2i", secondsRemaining / 60, secondsRemaining % 60];
    
    if(secondsRemaining == 0) {
        int blueScore = [[scores objectAtIndex:BLUE] intValue];
        int greenScore = [[scores objectAtIndex:GREEN] intValue];
        _teamWinsLabel.hidden = NO;
        if(blueScore > greenScore) {
            _teamWinsLabel.text = @"Blue Wins!";
            _teamWinsLabel.textColor = _blueScore.textColor;
        } else if(greenScore > blueScore) {
            _teamWinsLabel.text = @"Green Wins!";
            _teamWinsLabel.textColor = _greenScore.textColor;
        } else {
            _teamWinsLabel.text = @"Tie Game!";
            _teamWinsLabel.textColor = [UIColor blackColor];
        }
        isPaused = YES;
        return;
    }
    secondsRemaining--;
    [self performSelector:@selector(countSecond) withObject:nil afterDelay:1];
}

-(BOOL) isTimedMatch {
    return [defaults boolForKey:@"TimedMatch"];
}

-(int) playTo {
    return [[defaults objectForKey:@"PlayTo"] intValue];
}

-(int) matchLength {
    return [[defaults objectForKey:@"MatchLength"] intValue];
}

- (IBAction)resetGame:(id)sender {
    scores = [NSMutableArray arrayWithArray: @[@0, @0]];
    _blueScore.text = @"0";
    _greenScore.text = @"0";
    _teamWinsLabel.hidden = YES;
    isPaused = YES;
    secondsRemaining = [self matchLength]*60;
    _pauseButton.hidden = YES;
    _timeLabel.hidden = YES;
    if(![self isTimedMatch]) _startButton.hidden = YES;
    else _startButton.hidden = NO;
}

- (IBAction)blueButtonPressed:(id)sender {
    
    [self animateLabel:_blueScore];
    
    NSNumber *currentScore = [scores objectAtIndex:BLUE];
    int newScore = [currentScore intValue] + 1;
    scores[BLUE] = [NSNumber numberWithInt:newScore];
    _blueScore.text = [NSString stringWithFormat:@"%i", newScore];
    
    if(![self isTimedMatch] && newScore >= [self playTo]) {
        _teamWinsLabel.hidden = NO;
        _teamWinsLabel.text = @"Blue Wins!";
        _teamWinsLabel.textColor = _blueScore.textColor;
    }
}

- (IBAction)greenButtonPressed:(id)sender {
    
    [self animateLabel:_greenScore];
    
    NSNumber *currentScore = [scores objectAtIndex:GREEN];
    int newScore = [currentScore intValue] + 1;
    scores[GREEN] = [NSNumber numberWithInt:newScore];
    _greenScore.text = [NSString stringWithFormat:@"%i", newScore];
    
    if(![self isTimedMatch] && newScore >= [self playTo]) {
        _teamWinsLabel.hidden = NO;
        _teamWinsLabel.text = @"Green Wins!";
        _teamWinsLabel.textColor = _greenScore.textColor;
    }
}

@end











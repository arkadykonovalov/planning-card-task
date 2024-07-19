
% SCRIPT TO RUN PLANNING EXPERIMENT
% by Arkady Konovalov (arkady.konovalov@gmail.com)
% Version May 16 2023

% Clear the workspace and the screen
sca;
close all; 
clearvars;

%
temp = dir('data/csv/*.csv'); % check how many csv files in the datafolder
sessID = size(temp,1) + 1; % assign session ID 

rpsID = 999;


testTrials = 0;  % put number of trials > 0 to run for only that number of trials

% EXPERIMENT PARAMETERS

% EYE-TRACKING
eyeTracking = false; % set to true if want eye-tracking

% payment parameters
convertionRate = 500; % in points
showupFee = 30; % in pounds

suitsBonus = 20;
digitsBonus = 20;

totalBonusRate = 20;


maxRT = 10;  % maximal response time
timeITI = 1; % inter trial interval
timeFeedback = 0.5;
tutorialDelay = 0.5;

initialDeck = [102:106 202:206 302:306 402:406];

grid = [102:106; 202:206; 302:306; 402:406]';

deckIds = 1:size(initialDeck,2);

deckNames = {'a2', 'a3', 'a4', 'a5','a6', ...
    'b2', 'b3', 'b4', 'b5','b6', ...
    'c2', 'c3', 'c4', 'c5','c6', ...
    'd2', 'd3', 'd4', 'd5','d6' };

% loading card images
images = {};
for i = 1:size(deckNames,2)
    cardName = deckNames{i};
    images{i} = imread(['png_mri/' cardName '.png']);
end

imagesBig = {};
for i = 1:size(deckNames,2)
    cardName = deckNames{i};
    imagesBig{i} = imread(['png/' cardName '.png']);
end

Ntrials = 10;
Nrounds = 1;

% Set up Psychtoolbox
PsychDefaultSetup(2);

% Skeep sync tests (they don't work properly on Macs)
Screen('Preference', 'SkipSyncTests', 1);

% Set up the screen
screenNumber = max(Screen('Screens'));
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[wPtr, rect] = PsychImaging('OpenWindow', screenNumber, black);

% Set up the keyboard
KbName('UnifyKeyNames');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');

% Create a row of areas to display cards
res = [105*0.5 69*0.5];

rectA2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.41*rect(3), 0.7*rect(4));
rectB2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.47*rect(3), 0.7*rect(4));
rectC2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.53*rect(3), 0.7*rect(4));
rectD2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.59*rect(3), 0.7*rect(4));

rectA3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.41*rect(3), 0.75*rect(4));
rectB3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.47*rect(3), 0.75*rect(4));
rectC3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.53*rect(3), 0.75*rect(4));
rectD3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.59*rect(3), 0.75*rect(4));

rectA4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.41*rect(3), 0.8*rect(4));
rectB4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.47*rect(3), 0.8*rect(4));
rectC4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.53*rect(3), 0.8*rect(4));
rectD4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.59*rect(3), 0.8*rect(4));

rectA5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.41*rect(3), 0.85*rect(4));
rectB5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.47*rect(3), 0.85*rect(4));
rectC5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.53*rect(3), 0.85*rect(4));
rectD5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.59*rect(3), 0.85*rect(4));

rectA6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.41*rect(3), 0.9*rect(4));
rectB6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.47*rect(3), 0.9*rect(4));
rectC6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.53*rect(3), 0.9*rect(4));
rectD6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.59*rect(3), 0.9*rect(4));

positions = {rectA2, rectA3, rectA4, rectA5, rectA6,...
             rectB2, rectB3, rectB4, rectB5, rectB6,...
             rectC2, rectC3, rectC4, rectC5, rectC6,...
             rectD2, rectD3, rectD4, rectD5, rectD6};

% main two cards
res_card = [2*69 2*105];

rect_left = CenterRectOnPoint([0, 0, res_card(1), res_card(2)], 0.4*rect(3), 0.4*rect(4));
rect_right = CenterRectOnPoint([0, 0, res_card(1), res_card(2)], 0.6*rect(3), 0.4*rect(4));

positionsMain = {rect_left, rect_right};

% Set up the frame size and color
frameSize = 5;  % in pixels
frameColorChoice = [0.9, 0.8, 0.2];
frameColorChosen = [0.2, 1, 0.2];

% set history of sets
totalCombosSuits = 0;
totalCombosDigits = 0;

% create data
data = CreateData(rpsID, Ntrials, Nrounds);

trial = 1;


% start the eye tracker

if eyeTracking
    status = Eyelink('initialize');
    et = EyelinkInitDefaults(wPtr);
    et0 = 0;

    EyelinkInit(0);
    Eyelink('command', 'calibration_type = HV5');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TUTORIAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Screen('TextColor', wPtr, white);
Screen('TextSize', wPtr, 20);

% SCREEN 1

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['Welcome to the experiment.' '\n\n' ...
        '\n\n' 'Today you will play a simple card game.' ...
        '\n\n' 'Your goal is to get as many points as possible.'  ...
        '\n\n' 'In the end, we will convert the points into GBP.'  ...
        '\n\n' '\n\n' 'Press any key to continue.' ], ...
        0.1*rect(3),'center');
Screen('Flip',wPtr);

WaitSecs(tutorialDelay);
KbWait;

% SCREEN 2

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['Read the instructions carefully.' '\n\n' ...
        '\n\n' 'You will not be able to return to previous screens.'], ...
        0.1*rect(3),'center');
Screen('Flip',wPtr);

WaitSecs(tutorialDelay);
KbWait;


% SCREEN 3

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['In this tutorial, you will learn the rules and try the game.' '\n\n' ...
        '\n\n' 'In each game, you will start with 20 cards.'], ...
        0.1*rect(3),'center');
Screen('Flip',wPtr);

WaitSecs(tutorialDelay);
KbWait;


% SCREEN 5

%initialize display triggers
displayTriggers = [1 1 1 1 1 ...
    1 1 1 1 1 ...
    1 1 1 1 1 ...
    1 1 1 1 1];

hand = [];
handNames = [];

deck = initialDeck;

Screen('FillRect', wPtr, black);

DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['There are 4 suits of cards (denoted by symbols).' '\n\n' ...
        '\n\n' 'Each card is numbered from 2 to 6.' ...
        '\n\n' 'In total, there are 20 cards.' ...
        '\n\n' 'You will see a reminder about the deck at the bottom of the screen.'], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);

WaitSecs(tutorialDelay);
KbWait;

% SCREEN 6

displayTriggers = [1 1 2 1 1 ...
    1 1 1 1 1 ...
    1 1 1 2 1 ...
    1 1 1 1 1];
index1 = 3;
index2 = 14;
indices = [index1 index2];

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['In each round, computer will randomly select 2 cards.' '\n\n' ...
        '\n\n' '\n\n' 'They will light up like this and also will be shown in the middle of the screen.' ...
        '\n\n' 'You will need to choose one of the cards by pressing Left or Right Arrow keys.'...
        '\n\n' 'Try pressing left or right now.' ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);

WaitSecs(1);

%Wait for a response

t0 = GetSecs;
response = 0;
timer = 0;
while ~response % && timer < maxRT
    [keyIsDown, secs, keyCode] = KbCheck;
    timer = GetSecs -  t0;


    if keyIsDown

        if keyCode(leftKey)
            response = 1;

            displayTriggers(index1) = 3;
            displayTriggers(index2) = 0;

            frameRect = positions{index1} + [-frameSize, -frameSize, frameSize, frameSize];

        elseif keyCode(rightKey)
            response = 2;

            displayTriggers(index2) = 3;
            displayTriggers(index1) = 0;

            frameRect = positions{index2} + [-frameSize, -frameSize, frameSize, frameSize];
        end
    end
end

%Draw a choice frame
DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);

DrawFormattedText(wPtr,['You will keep the chosen card.' '\n\n' ...
        '\n\n' 'It will be highlighted in green below.' ...
        '\n\n' 'The other card will disappear for this game.'...
        '\n\n' 'The computer will then select 2 new cards.' ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

if response == 1
    displayTriggers(index1) = 4;
elseif response == 2
    displayTriggers(index2) = 4;
end

% SCREEN 6

displayTriggers(5) = 2;
displayTriggers(11) = 2;
index1 = 5;
index2 = 11;
indices = [index1 index2];

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['For instance, like this.' '\n\n' ...
        '\n\n' 'It will never return to cards' ...
        '\n\n' 'that were previously chosen, since they disappear.'...
        '\n\n' 'Press any key to continue.' ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;


% SCREEN 7

displayTriggers([6 2 7 8 12 13 14 16 18 19]) = 0;
displayTriggers([1 3 4 5 9 10 15 11 17 20]) = 4;


Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['You will keep chosing until'  ...
        '\n\n' 'there are only 10 cards left.' ...
        '\n\n' 'Then the game will calculate your points.' '\n\n' ...
        '\n\n' 'Pressy any key to continue.' ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 8

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['For instance, let''s say you have these cards in the end.'  ...
        '\n\n' 'First, you will receive a sum of points' ...
        '\n\n' 'for all numbers on the cards that you have.' '\n\n' ...
        '\n\n' 'Here, you will get 45 points.' ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 9

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['Additionally, you will get 20 bonus points for'  ...
        '\n\n' 'each set of 4 cards of the same suit (symbol)' ...
        '\n\n' 'and each set of 4 cards with the same number.' '\n\n' ...
        '\n\n' 'Sets can overlap!' '\n\n' ...
        '\n\n' 'Here, one set of sixes (the very bottom row)' ...
        '\n\n' 'and one set of clubs (crosses).' ...
        ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 10

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['Each set gives you 20 bonus points.'  ...
        '\n\n' 'So you would get 45 points from the cards' ...
        '\n\n' 'and 40 points for having 2 sets.' '\n\n' ...
        '\n\n' 'In total, in this game you would get 85 points. ' ...
        ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 10

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['Importantly, the set of the same suit'  ...
        '\n\n' 'can be any numbers, they do not have to be in a row!' ...
        '\n\n' 'So you can have, for instance, 2, 4, 5, 6' ...
        '\n\n' 'of clubs to get the bonus. ' ...
        ], ...
        0.05*rect(3),'center');
Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 10

Screen('FillRect', wPtr, black);

DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
DrawFormattedText(wPtr,['After the game, you will see a summary'  ...
        '\n\n' 'as you can see on the right.' '\n\n' ...
        '\n\n' 'Notice you will also see a total count of sets.'  ...
        '\n\n' 'This is important as you will collect these ' ...
        '\n\n' 'across multiple games. ' ...
        ], ...
        0.05*rect(3),'center');

 DrawFormattedText(wPtr,['THIS ROUND' '\n\n' 'Sum of points: ' num2str(45) ...
        '\n\n' 'Number of suits sets: ' num2str(1) ...
        '\n\n' 'Number of digits sets: ' num2str(1) ...
        '\n\n' 'Total points: ' num2str(85) ...
         ], ...
        0.75*rect(3),'center');

    DrawFormattedText(wPtr,['OVERALL' ...
        '\n\n' 'Total number of suits sets: ' num2str(1) ...
        '\n\n' 'Total number of digits sets: ' num2str(1)], ...
        0.75*rect(3),0.75*rect(4));

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 11

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['In the scanner, you will play 30 games.'  ...
        '\n\n' 'For instance, after all games you have'  ...
        '\n\n' 'collected 10 sets of suits and 3 sets'  ...
        '\n\n' 'of numbers as shown on the right. ' '\n\n' ...
        '\n\n' 'The computer will choose the largest number (10>3) ' ...
        '\n\n' 'and multiply it by 20 for your final bonus. ' ...
        ], ...
        0.05*rect(3),'center');

 DrawFormattedText(wPtr,['THIS ROUND' '\n\n' 'Sum of points: ' num2str(55) ...
        '\n\n' 'Number of suits sets: ' num2str(2) ...
        '\n\n' 'Number of digits sets: ' num2str(0) ...
        '\n\n' 'Total points: ' num2str(95) ...
         ], ...
         0.75*rect(3),'center');

    DrawFormattedText(wPtr,['OVERALL' ...
        '\n\n' 'Total number of suits sets: ' num2str(10) ...
        '\n\n' 'Total number of digits sets: ' num2str(3)], ...
        0.75*rect(3),0.75*rect(4));

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 12

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['In this case, you will get'  ...
        '\n\n' '10 x 20 = 200 final bonus points'  ...
        '\n\n' 'in addition to the points you got in'  ...
        '\n\n' 'each single game. ' '\n\n' ...
        '\n\n' 'So your points will come from cards and sets in each game,  ' ...
        '\n\n' 'and from collections of sets across games.' ...
        ], ...
        0.05*rect(3),'center');

 DrawFormattedText(wPtr,['THIS ROUND' '\n\n' 'Sum of points: ' num2str(55) ...
        '\n\n' 'Number of suits sets: ' num2str(2) ...
        '\n\n' 'Number of digits sets: ' num2str(0) ...
        '\n\n' 'Total points: ' num2str(95) ...
         ], ...
        0.75*rect(3),'center');

    DrawFormattedText(wPtr,['OVERALL' ...
        '\n\n' 'Total number of suits sets: ' num2str(10) ...
        '\n\n' 'Total number of digits sets: ' num2str(3)], ...
        0.75*rect(3),0.75*rect(4));

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;


% SCREEN 13

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['The absolute maximum of points you can get'  ...
        '\n\n' 'in a single game is 111 points (set of 6s + set of 5s + one suit set).'  ...
        '\n\n' 'Over 30 games this could be 3330 points maximum.' '\n\n' ...
        '\n\n' 'If you collect only sets of one type (suits or numbers) '  ...
        '\n\n' 'you get a larger final bonus.' ...
        ], ...
        'center','center');

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 13

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['At the end of the experiment, your points will be converted to pounds'  ...
        '\n\n' 'at the rate of ' num2str(convertionRate) ' points = 1 pound.'  ...
        '\n\n' 'You will also receive a ' num2str(showupFee) ' pounds participation fee.' '\n\n' ...
        ], ...
        'center','center');

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;

% SCREEN 13

Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['Now try and play one practice game.'  ...
        '\n\n' 'Press any key to start.'  ...
        ], ...
        'center','center');

Screen('Flip', wPtr);
WaitSecs(tutorialDelay);
KbWait;


Screen('Close');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN EXPERIMENT LOOP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for game = 1:Nrounds

    % initialize display triggers
    displayTriggers = [1 1 1 1 1 ...
                    1 1 1 1 1 ...
                    1 1 1 1 1 ...
                    1 1 1 1 1];

    hand = [];
    handNames = [];

    deck = initialDeck;

    %record round starting time
    t0 = GetSecs;

    for strial = 1:Ntrials

        data.block(trial) = game;
        data.btrial(trial) = strial;

        DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, [0 0], wPtr, frameSize, frameColorChoice, frameColorChosen);
        Screen('Flip', wPtr);
        WaitSecs(timeITI);

        shuffledDeck = Shuffle(deck);

        cardDraw = shuffledDeck(1:2);

        data.option1(trial) = cardDraw(1);
        data.option2(trial) = cardDraw(2);

        cardDrawName1 = deckNames(initialDeck == cardDraw(1));
        cardDrawName2 = deckNames(initialDeck == cardDraw(2));

        index1 = initialDeck == cardDraw(1);
        index2 = initialDeck == cardDraw(2);
        indices = [find(index1==1) find(index2==1)];

        displayTriggers(index1) = 2;
        displayTriggers(index2) = 2;

       DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
        Screen('Flip', wPtr);

        % record stimuli onset time
        data.onset(trial) = GetSecs - t0;

        if eyeTracking
            evt = Eyelink('newestfloatsample');
            data.onset_et(trial) = evt.time - et0;
        end

        cardDrawNames = [cardDrawName1{1} ' ' cardDrawName2{1}];

        deck = setdiff(deck,cardDraw);

        disp(['Trial ' num2str(trial)]);
        disp(['Your hand is ' num2str(handNames)]);
        disp(['Choose: ' num2str(cardDrawNames)]);

        data.card1(trial) = displayTriggers(1);
        data.card2(trial) = displayTriggers(2);
        data.card3(trial) = displayTriggers(3);
        data.card4(trial) = displayTriggers(4);
        data.card5(trial) = displayTriggers(5);
        data.card6(trial) = displayTriggers(6);
        data.card7(trial) = displayTriggers(7);
        data.card8(trial) = displayTriggers(8);
        data.card9(trial) = displayTriggers(9);
        data.card10(trial) = displayTriggers(10);
        data.card11(trial) = displayTriggers(11);
        data.card12(trial) = displayTriggers(12);
        data.card13(trial) = displayTriggers(13);
        data.card14(trial) = displayTriggers(14);
        data.card15(trial) = displayTriggers(15);
        data.card16(trial) = displayTriggers(16);
        data.card17(trial) = displayTriggers(17);
        data.card18(trial) = displayTriggers(18);
        data.card19(trial) = displayTriggers(19);
        data.card20(trial) = displayTriggers(20);

        % Wait for a response
        response = 0;
        timer = 0;
        while ~response % && timer < maxRT
            [keyIsDown, secs, keyCode] = KbCheck;
            timer = GetSecs -  data.onset(trial) - t0;
           
            if keyIsDown 

                % record response time
                data.rt(trial) = GetSecs - data.onset(trial) - t0;
                data.response(trial) = GetSecs - t0;

       
                if eyeTracking
                    evt = Eyelink('newestfloatsample');
                    data.response_et(trial) = evt.time - et0;
                end

                if keyCode(leftKey)
                    response = 1;
                    data.choice(trial) = 1;
                    data.payoff(trial) = rem(cardDraw(1),100);

                    handNames = [handNames ' ' cardDrawName1{1}];
                    hand = [hand cardDraw(1)];

                    displayTriggers(index1) = 3;
                    displayTriggers(index2) = 0;

                    frameRect = positions{index1} + [-frameSize, -frameSize, frameSize, frameSize];

                elseif keyCode(rightKey)
                    response = 2;
                    data.choice(trial) = 2;
                    data.payoff(trial) = rem(cardDraw(2),100);

                    handNames = [handNames ' ' cardDrawName2{1}];
                    hand = [hand cardDraw(2)];

                    displayTriggers(index2) = 3;
                    displayTriggers(index1) = 0;

                    frameRect = positions{index2} + [-frameSize, -frameSize, frameSize, frameSize];
                end
            end
        end

        % Record feedback timing
        data.feedback_onset(trial) = GetSecs - t0;

        if eyeTracking
            evt = Eyelink('newestfloatsample');
            data.feedback_onset_et(trial) = evt.time - et0;
        end

        % Draw a choice frame
        DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);
        Screen('Flip', wPtr);
        WaitSecs(1);

        Screen('Close');

        if response == 1
            displayTriggers(index1) = 4;
        elseif response == 2
            displayTriggers(index2) = 4;
        end

        % increase trial count
        trial = trial + 1;
    end


    disp(['ROUND END']);
    disp(['Your final hand is ' num2str(handNames)]);

    sumPoints = sum(rem(hand,100));

    distDigits = tabulate(rem(hand,100));
    nCombosDigits = sum(distDigits(:,2) >= 4);

    suits = round(hand/100);
    distSuits = tabulate(suits);
    nCombosSuits = sum(distSuits(:,2) >= 4);
    totalPoints = sumPoints + nCombosSuits*suitsBonus + nCombosDigits*digitsBonus;

    disp(['Sum of points is ' num2str(sumPoints)]);
    disp(['Number of suits combinations: ' num2str(nCombosSuits)]);
    disp(['Number of digits combinations: ' num2str(nCombosDigits)]);
    disp(['Total points: ' num2str(totalPoints)]);

    data.blockpoints(data.block == game) = sumPoints;
    data.blocksuits(data.block == game) = nCombosSuits;
    data.blockdigits(data.block == game) = nCombosDigits;
    data.blocktotalpoints(data.block == game) = totalPoints;

    % Points display
    Screen('FillRect', wPtr, black);

    DrawStimuliMRI(images, imagesBig, positions, positionsMain, displayTriggers, indices, wPtr, frameSize, frameColorChoice, frameColorChosen);

    Screen('TextColor', wPtr, white);
    Screen('TextSize', wPtr, 20);

    totalCombosSuits = totalCombosSuits + nCombosSuits;
    totalCombosDigits = totalCombosDigits + nCombosDigits;

    DrawFormattedText(wPtr,['THIS ROUND' '\n\n' 'Sum of points: ' num2str(sumPoints) ...
        '\n\n' 'Number of suits sets: ' num2str(nCombosSuits) ...
        '\n\n' 'Number of digits sets: ' num2str(nCombosDigits) ...
        '\n\n' 'Total points: ' num2str(totalPoints) ...
        '\n\n' 'Press any key to continue.'], ...
        0.75*rect(3),'center');

    DrawFormattedText(wPtr,['OVERALL' ...
        '\n\n' 'Total number of suits sets: ' num2str(totalCombosSuits) ...
        '\n\n' 'Total number of digits sets: ' num2str(totalCombosDigits)], ...
        0.75*rect(3),0.75*rect(4));

    Screen('Flip',wPtr);

    % Save data
    save(['data/mat/data_' int2str(rpsID) '.mat']);

    WaitSecs(timeFeedback);
    KbWait;

end


% Screen
Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['A few final rules.' '\n\n' ...
    'In the scanner, you will use a button box instead of a keyboard.' '\n\n' ...
    'Each choice will be restricted to 3 seconds.' '\n\n' ...
    'If you fail to respond within that limit, both cards will be removed.' '\n\n' ...
    '\n\n Finally, to maximize the neural signal, trials will be separated by up to 6 seconds.' '\n\n' ...
    'Please be patient.' '\n\n' ...
   '\n\n Press any key now.' '\n\n' ...
       ], ...
       'center','center');

Screen('Flip',wPtr);
WaitSecs(5);
KbWait;



% Final screen
Screen('FillRect', wPtr, black);

DrawFormattedText(wPtr,['This is the end of the tutorial.' '\n\n' ...
    'Please tell the experimenter that you have finished.' '\n\n' ...
       ], ...
       'center','center');

Screen('Flip',wPtr);
WaitSecs(5);
KbWait;

Screen('CloseAll');



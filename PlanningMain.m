
% SCRIPT TO RUN PLANNING EXPERIMENT
% by Arkady Konovalov (arkady.konovalov@gmail.com)
% Version Sep 19 2023

% Clear the workspace and the screen
sca;
close all; 
clearvars;

%
temp = dir('data/csv/*.csv'); % check how many csv files in the datafolder
sessID = size(temp,1) + 1; % assign session ID 



testTrials = 0;  % put number of trials > 0 to run for only that number of trials

% EXPERIMENT PARAMETERS

% EYE-TRACKING
eyeTracking = false; % set to true if want eye-tracking

% payment parameters
convertionRate = 500; % in points
showupFee = 7; % in pounds

suitsBonus = 20;
digitsBonus = 20;

maxRT = 10;  % maximal response time
timeITI = 1; % inter trial interval
timeFeedback = 0.5;

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
    images{i} = imread(['png/' cardName '.png']);
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
res = [69*1.5 105*1.5];

rectA2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.35*rect(3), rect(4)/10);
rectB2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.45*rect(3), rect(4)/10);
rectC2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.55*rect(3), rect(4)/10);
rectD2 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.65*rect(3), rect(4)/10);

rectA3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.35*rect(3), 3*rect(4)/10);
rectB3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.45*rect(3), 3*rect(4)/10);
rectC3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.55*rect(3), 3*rect(4)/10);
rectD3 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.65*rect(3), 3*rect(4)/10);

rectA4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.35*rect(3), rect(4)/2);
rectB4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.45*rect(3), rect(4)/2);
rectC4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.55*rect(3), rect(4)/2);
rectD4 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.65*rect(3), rect(4)/2);

rectA5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.35*rect(3), 7*rect(4)/10);
rectB5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.45*rect(3), 7*rect(4)/10);
rectC5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.55*rect(3), 7*rect(4)/10);
rectD5 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.65*rect(3), 7*rect(4)/10);

rectA6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.35*rect(3), 9*rect(4)/10);
rectB6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.45*rect(3), 9*rect(4)/10);
rectC6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.55*rect(3), 9*rect(4)/10);
rectD6 = CenterRectOnPoint([0, 0, res(1), res(2)], 0.65*rect(3), 9*rect(4)/10);

positions = {rectA2, rectA3, rectA4, rectA5, rectA6,...
             rectB2, rectB3, rectB4, rectB5, rectB6,...
             rectC2, rectC3, rectC4, rectC5, rectC6,...
             rectD2, rectD3, rectD4, rectD5, rectD6};

% Set up the frame size and color
frameSize = 5;  % in pixels
frameColorChoice = [0.9, 0.8, 0.2];
frameColorChosen = [0.2, 1, 0.2];

% set history of sets
totalCombosSuits = 0;
totalCombosDigits = 0;

% create data
data = CreateData(sessID, Ntrials, Nrounds);

trial = 1;


% start the eye tracker

if eyeTracking
    status = Eyelink('initialize');
    et = EyelinkInitDefaults(wPtr);
    et0 = 0;

    EyelinkInit(0);
    Eyelink('command', 'calibration_type = HV5');

end

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
       
        DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen);
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

        displayTriggers(index1) = 2;
        displayTriggers(index2) = 2;

        DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen);
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

        % Wait for a response
        response = 0;
        timer = 0;
        while ~response % && timer < maxRT
            [keyIsDown, secs, keyCode] = KbCheck;
            timer = GetSecs -  data.onset(trial) - t0;
            [x,y,buttons] = GetMouse(wPtr);

            ROI1 = positions{index1};
            ROI2 = positions{index2};

            if any(buttons) && ((x > ROI1(1) && x < ROI1(3)) || (x > ROI2(1) && x < ROI2(3))) && ((y > ROI1(2) && y < ROI1(4)) || (y > ROI2(2) && y < ROI2(4)))

                % record response time
                data.rt(trial) = GetSecs - data.onset(trial) - t0;
                data.response(trial) = GetSecs - t0;

                finalx = x;
                finaly = y;

                if eyeTracking
                    evt = Eyelink('newestfloatsample');
                    data.response_et(trial) = evt.time - et0;
                end

                if (finalx > ROI1(1) && finalx < ROI1(3)) && (finaly > ROI1(2) && finaly < ROI1(4))
                    response = 1;
                    data.choice(trial) = 1;
                    data.payoff(trial) = rem(cardDraw(1),100);

                    handNames = [handNames ' ' cardDrawName1{1}];
                    hand = [hand cardDraw(1)];

                    displayTriggers(index1) = 3;
                    displayTriggers(index2) = 0;

                    frameRect = positions{index1} + [-frameSize, -frameSize, frameSize, frameSize];

                elseif (finalx > ROI2(1) && finalx < ROI2(3)) && (finaly > ROI2(2) && finaly < ROI2(4))
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
        DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen);
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

    DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen);

    Screen('TextColor', wPtr, white);
    Screen('TextSize', wPtr, 20);
    
    totalCombosSuits = totalCombosSuits + nCombosSuits;
    totalCombosDigits = totalCombosDigits + nCombosDigits;

    DrawFormattedText(wPtr,['THIS ROUND' '\n\n' 'Sum of points: ' num2str(sumPoints) ...
        '\n\n' 'Number of suits sets: ' num2str(nCombosSuits) ...
        '\n\n' 'Number of digits sets: ' num2str(nCombosDigits) ...
        '\n\n' 'Total points: ' num2str(totalPoints) ...
        '\n\n' 'Click anywhere to continue.'], ...
        0.75*rect(3),'center');

    DrawFormattedText(wPtr,['OVERALL' ...
        '\n\n' 'Total number of suits sets: ' num2str(totalCombosSuits) ...
        '\n\n' 'Total number of digits sets: ' num2str(totalCombosDigits)], ...
        0.75*rect(3),0.75*rect(4));

    Screen('Flip',wPtr);
    
    % Save data
    save(['data/mat/data_' int2str(sessID) '.mat']);

    WaitSecs(timeFeedback);
    MbWait(wPtr);

end

if eyeTracking
    Eyelink('shutdown');
end

writetable(data,['data/csv/data_' int2str(sessID) '.csv']);

% Final screen
Screen('FillRect', wPtr, black);

payment = round(sum(data.payoff)/convertionRate);
DrawFormattedText(wPtr,['This is the end of the experiment.' '\n\n' ' Your total points are ' num2str(sum(data.payoff)) '.'], ...
       'center','center');
Screen('Flip',wPtr);
WaitSecs(15);
%MbWait;


Screen('CloseAll');

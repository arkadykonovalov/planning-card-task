function DrawStimuli(images, positions, displayTriggers, wPtr, frameSize, frameColorChoice, frameColorChosen)

screenNumber = max(Screen('Screens'));
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

Screen(wPtr, 'FillRect', black); 

multiplier = 1;

for i = 1:size(positions,2)

    if displayTriggers(i) == 1  
        multiplier = 0.3;  % initial brightness
    elseif displayTriggers(i) == 2

        multiplier = 0.8;  % choice  brightness
        frameRect = positions{i} + [-frameSize, -frameSize, frameSize, frameSize];
        Screen('FrameRect', wPtr, frameColorChoice, frameRect, frameSize);

    elseif displayTriggers(i) == 3

        multiplier = 1;  % choice brightness
        frameRect = positions{i} + [-frameSize, -frameSize, frameSize, frameSize];
        Screen('FrameRect', wPtr, frameColorChosen, frameRect, frameSize);

    elseif displayTriggers(i) == 4

        multiplier = 1;  % stay brightness

    elseif displayTriggers(i) == 0
        multiplier = 0;  % not chosen brightness
    end

    texture = Screen('MakeTexture', wPtr, multiplier*images{i});
    Screen('DrawTexture', wPtr, texture, [], positions{i});
end


end
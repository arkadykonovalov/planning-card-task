function MbWait(wPtr)

WaitSecs(0.01);



FlushEvents('mouseDown');

decision = 0;
buttons = -1;

while decision == 0

       [x,y,buttons] = GetClicks(wPtr);

       if any(buttons) 
          decision = 1;
       end

end



end
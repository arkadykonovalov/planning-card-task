function data = CreateData(sessID, Ntrials, Nrounds)
% THIS FUNCTION CREATES THE DATA FRAME WITH RANDOM ORDER OF CONDITIONS AND
% TRIALS


% Converting into a dataframe
data = array2table(sessID.*ones(Ntrials*Nrounds,1),'VariableNames',{'id'});

% Adding variables
data.uniqueID = round(rand*100000000)*ones(size(data,1),1);
data.trial = [1:size(data,1)]';
data.block = -999*ones(size(data,1),1);
data.btrial = -999*ones(size(data,1),1);
data.choice = -999*ones(size(data,1),1);
data.option1 = -999*ones(size(data,1),1);
data.option2 = -999*ones(size(data,1),1);

data.card1 = -999*ones(size(data,1),1);
data.card2 = -999*ones(size(data,1),1);
data.card3 = -999*ones(size(data,1),1);
data.card4 = -999*ones(size(data,1),1);
data.card5 = -999*ones(size(data,1),1);
data.card6 = -999*ones(size(data,1),1);
data.card7 = -999*ones(size(data,1),1);
data.card8 = -999*ones(size(data,1),1);
data.card9 = -999*ones(size(data,1),1);
data.card11 = -999*ones(size(data,1),1);
data.card12 = -999*ones(size(data,1),1);
data.card13 = -999*ones(size(data,1),1);
data.card14 = -999*ones(size(data,1),1);
data.card15 = -999*ones(size(data,1),1);
data.card16 = -999*ones(size(data,1),1);
data.card17 = -999*ones(size(data,1),1);
data.card18 = -999*ones(size(data,1),1);
data.card19 = -999*ones(size(data,1),1);
data.card20 = -999*ones(size(data,1),1);

data.choice = -999*ones(size(data,1),1);

data.payoff = -999*ones(size(data,1),1);
data.blockpoints = -999*ones(size(data,1),1);
data.blocksuits = -999*ones(size(data,1),1);
data.blockdigits = -999*ones(size(data,1),1);
data.blocktotalpoints = -999*ones(size(data,1),1);

data.rt = -999*ones(size(data,1),1);
data.onset = -999*ones(size(data,1),1);
data.response = -999*ones(size(data,1),1);
data.feedback_onset = -999*ones(size(data,1),1);

data.onset_et = -999*ones(size(data,1),1);
data.response_et = -999*ones(size(data,1),1);
data.feedback_onset_et = -999*ones(size(data,1),1);
data.ITI_onset_et = -999*ones(size(data,1),1);




end
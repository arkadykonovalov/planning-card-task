function data = CreateData(sessID, Ntrials, Nrounds)
% THIS FUNCTION CREATES THE DATA FRAME WITH RANDOM ORDER OF CONDITIONS AND
% TRIALS


% Converting into a dataframe
data = array2table(sessID.*ones(Ntrials*Nrounds,1),'VariableNames',{'id'});

% Adding variables
data.trial = [1:size(data,1)]';
data.block = -999*ones(size(data,1),1);
data.btrial = -999*ones(size(data,1),1);
data.choice = -999*ones(size(data,1),1);
data.option1 = -999*ones(size(data,1),1);
data.option2 = -999*ones(size(data,1),1);
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
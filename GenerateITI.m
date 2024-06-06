

Ntrials = 10;
Nrounds = 10;

ITI = 2 + 4.*rand(Ntrials,Nrounds);

save('ITI.mat','ITI');
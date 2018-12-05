%% Visual Search Experiment Replication
% Denpendencies: This program is based on MATLAB version 2017b (Mac)
% Version History: I don't remember......since there are too many
%% Initialization
%clear wark space
clear all
close all
clc
%initialization of variables
Trials =nan(20,5); % initialization for 20 trials per level per condition
CorrectTrials =[]; % the final 160 trials will be stored into this matrix
%% parameters
setsize = [4 8 12 16];
condition = [0 1]; % 1 represents pop out search, 0 represents conjunction search
Trials =nan(20,5); % initialization for 20 trials per level per condition
CorrectTrials =[]; % the final 160 trials will be stored into this matrix
fS = 20; %set the font size for stimuli
Fs = 40; %font size for welcome&thank you text
lW = 1; %set the line width
%% Stimuli presentation and reaction time recording
% display welcome info
figure
screensize = get(0,'ScreenSize');
set(gcf,'Position',screensize);
Welcometext = text(.5,.5,'Welcome!');
axis off
set(gcf,'color','k');
set(Welcometext,'HorizontalAlignment','center');
set(Welcometext,'color','w')
set(Welcometext,'FontSize',Fs);
set(Welcometext,'FontWeight','b');
shg
pause
delete(Welcometext)
%display instruction
message = sprintf('The target is red ''x'' only.\n Press ''y'' if the target is present.\n Press ''n'' if it''s not.\n Now press any key to proceed.');
Instructiontext = text(.5,.5,message);
% Instructiontext = text(.5,.5,)
% Instructiontext = text(.5,.5,);
axis off
set(gcf,'color','k');
set(Instructiontext,'HorizontalAlignment','center');
set(Instructiontext,'color','w')
set(Instructiontext,'FontSize',fS);
set(Instructiontext,'FontWeight','b');
shg
pause
delete(Instructiontext)
% display stimuli
for numStim = setsize(randperm(4)) %randomly draw one set size from the set [4 8 12 16] without replacement so that each size will appear only once
    for researchMethod = condition(randperm(2)) %randomly draw one condition, either pop out or conjunction
        j = 1; %initialize trial number at the beginning of each iteration
        TargetSet = [zeros(1,10) ones(1,10)];%for these 20 trials/level/condition, we want half with target, half without, so we create a vector with 0 and 1 first
        numTarget = randperm(20);            % and then get a vector of numbers from 1 to 20 with shuffled order
        while j<= 20 %we want 20 trials per level per condition, so 20 is the benchmark
            targetPresent = TargetSet(numTarget(j));% use the shuffled set as index to retrive 0 and 1 in TargetSet to nake sure there are equal number of target trials and non-target trials
            if targetPresent == 1 % check if target is present and output
                Target = 'x'; %tell the participant explicitly that the target is a red 'x'
                Target_pos = rand(targetPresent,2);
                TargetOutput = text(Target_pos(:,1),Target_pos(:,2),Target);
                set(TargetOutput,'color','r');
                set(TargetOutput,'FontSize',fS);
                set(TargetOutput,'FontWeight','b');
                Trials(j,1) = 'y'; % if there is target, put 'y' for 'yes' in the first column of Trials
            else
                Trials(j,1) = 'n'; % if there is no target, put 'n' for 'no'
            end       
            stimPresent = numStim-targetPresent; % a general representation of the number of stimuli presented
            stimuli = randperm(stimPresent);
            StimToDisp = cell(1,length(stimuli));% create a 1xlength(stimuli) cell to store stimuli
            ColorToDisp = cell(1,length(stimuli));% create a 1xlength(stimuli) cell to store the color for each stimuli         
            for i = 1:length(stimuli)
                if stimuli(i) <= numStim/2 %stimuli is the shuffled set, so we use i to retrieve any value in stimuli, it's either larger or smaller than half of the set size, so we just use smaller here
                    StimToDisp{i} = 'o';   % and if it's smaller, we want the distractors be 'o'
                    if ((stimuli(i) ~= 1) && (targetPresent == 1) && (researchMethod == 0)) || ((targetPresent == 0) && (researchMethod == 0)) %for conjunction search, if there is a target represented by red 'x', there need to be one and only one green 'o' to make sure there are eqaul number of red/green stimuli and equal number of 'x'/'o'
                                                                                          %but in pop out search, all 'o's are green, so we just need to change all other 'o's to red in conjunction search                      
                        ColorToDisp{i} = [1 0 0]; %the RGB tripplet for red
                    else ColorToDisp{i} = [0 1 0];%the RGB tripplet for green
                    end
                else StimToDisp{i} = 'x'; %let the other half be 'x' so that the number of 'x' and 'o' are equal
                    ColorToDisp{i} = [0 1 0];
                end
            end           
            StimToDisp_pos = rand(stimPresent,2); %random pairs of position index
            StimOutput = text(StimToDisp_pos(:,1),StimToDisp_pos(:,2),StimToDisp); % handle for stimuli
            set(StimOutput,'FontSize',fS);
            set(StimOutput,'FontWeight','b');
            for i = 1:length(stimuli) 
                set(StimOutput(i),'color',ColorToDisp{i}); %retrieve the color stored for each stimuli
            end                
            axis off;
            set(gcf,'color','k')
            validKeyPressed = 0; %Initialize this as zero          
            while validKeyPressed == 0 
                tic
                disp ('Press ''y'' for yes, ''n'' for no, please don''t press anything else. ')
                pause
                Trials(j,3) = toc; %let the third column of Trials be the reaction time
                userPressedKey = get(gcf,'CurrentCharacter'); %stored the key participant pressed
                Trials(j,2) = userPressedKey; %stored the key participant pressed in the second column of Trials              
                if strcmp (userPressedKey,'y') 
                    validKeyPressed = 1;
                elseif strcmp (userPressedKey,'n')
                    validKeyPressed = 1;
                else
                    disp('You pressed an invalid key, please try again!')
                    validKeyPressed = 2; %inform the participant the key he/she pressed is invalid, but keep this trial for now (will delete later) so that the time won't be cumulated to the next time when a valid key is pressed
                end              
            end           
            Trials(j,4) = numStim; %store the set size in the forth column of Trials (for analyzation)
            Trials(j,5) = researchMethod; %store whether it's conjunction search or pop out search in the fifth column of Trials           
            delete(StimOutput)
            if targetPresent == 1
                delete(TargetOutput)
            end         
            if Trials(j,1)== Trials(j,2) %the first column indicates whether the target is present, the second indicates the answer of each participant
                j = j + 1; %if the first two column matches, the participant made the right choice. So he/she can proceed to next trial
            end
        end       
        CorrectTrials = [CorrectTrials;Trials]; %apend the current set of trials to the total set of trials
    end   
end
%display thank you info
Thankyoutext = text(.5,.5,'Thank you!');
axis off
set(gcf,'color','k');
set(Thankyoutext,'HorizontalAlignment','center');
set(Thankyoutext,'color','w')
set(Thankyoutext,'FontSize',Fs);
set(Thankyoutext,'FontWeight','b');
pause(2) %the figure will pause for 2 seconds
close %and close automatically
%% Analyze reaction time and make result plots
%calculate the mean reaction time for pop out search for each set size no matter target is present or not
%since CorrectTrials is a numerical matrix, it transfers 'y' and 'n' to
%numbers, where 121 indicates 'y'(target present), and 110 indicates 'n'(target absent)
meanRT_pop4= mean(CorrectTrials((CorrectTrials(:,4)==4 & CorrectTrials(:,5) == 1),3));
meanRT_pop8= mean(CorrectTrials((CorrectTrials(:,4)==8 & CorrectTrials(:,5) == 1),3));
meanRT_pop12= mean(CorrectTrials((CorrectTrials(:,4)==12 & CorrectTrials(:,5) == 1),3));
meanRT_pop16= mean(CorrectTrials((CorrectTrials(:,4)==16 & CorrectTrials(:,5) == 1),3));
%conbine it into a vector for plotting
mean_pop = [meanRT_pop4 meanRT_pop8 meanRT_pop12 meanRT_pop16];
%calculate the mean reaction time for conjunction search for each set size no matter target is present or not
meanRT_conjunct4 = mean(CorrectTrials((CorrectTrials(:,4)==4 & CorrectTrials(:,5) == 0),3));
meanRT_conjunct8 = mean(CorrectTrials((CorrectTrials(:,4)==8 & CorrectTrials(:,5) == 0),3));
meanRT_conjunct12 = mean(CorrectTrials((CorrectTrials(:,4)==12 & CorrectTrials(:,5) == 0),3));
meanRT_conjunct16 = mean(CorrectTrials((CorrectTrials(:,4)==16 & CorrectTrials(:,5) == 0),3));
mean_conjunct = [meanRT_conjunct4 meanRT_conjunct8 meanRT_conjunct12 meanRT_conjunct16];
%calculate the mean reaction time when target is present for each set size
meanRT_4_target = mean(CorrectTrials((CorrectTrials(:,1)==121 & CorrectTrials(:,4)==4),3));
meanRT_8_target = mean(CorrectTrials((CorrectTrials(:,1)==121 & CorrectTrials(:,4)==8),3));
meanRT_12_target = mean(CorrectTrials((CorrectTrials(:,1)==121 & CorrectTrials(:,4)==12),3));
meanRT_16_target = mean(CorrectTrials((CorrectTrials(:,1)==121 & CorrectTrials(:,4)==16),3));
mean_target = [meanRT_4_target meanRT_8_target meanRT_12_target meanRT_16_target];
%calculate the mean reaction time when target is absent for each set size
meanRT_4_notarget = mean(CorrectTrials((CorrectTrials(:,1)==110 & CorrectTrials(:,4)==4),3));
meanRT_8_notarget = mean(CorrectTrials((CorrectTrials(:,1)==110 & CorrectTrials(:,4)==8),3));
meanRT_12_notarget = mean(CorrectTrials((CorrectTrials(:,1)==110 & CorrectTrials(:,4)==12),3));
meanRT_16_notarget = mean(CorrectTrials((CorrectTrials(:,1)==110 & CorrectTrials(:,4)==16),3));
mean_notarget = [meanRT_4_notarget meanRT_8_notarget meanRT_12_notarget meanRT_16_notarget];
%making the plot
subplot(2,1,1)
RT_pop = plot(setsize,mean_pop);
set(RT_pop,'LineWidth',lW);
set(RT_pop,'color','b');
hold on
RT_conjunct = plot(setsize,mean_conjunct);
set(RT_conjunct,'LineWidth',lW);
set(RT_conjunct,'color','r');
legend([RT_pop, RT_conjunct], 'Pop Out Search', ...
    'Conjunction Search','Location', 'SouthEastOutside');
title('Reaction Time under Pop out/Conjunction Search');
xlabel('Set Size');
ylabel('Reaction Time (s)');
set(gca,'Xtick',4:4:16); 
subplot(2,1,2)
RT_target = plot(setsize,mean_target);
set(RT_target,'LineWidth',lW);
set(RT_target,'color','b');
hold on
RT_notarget = plot(setsize,mean_notarget);
set(RT_notarget,'LineWidth',lW);
set(RT_notarget,'color','r');
legend([RT_target, RT_notarget], 'Target Present', ...
    'Target Absent','Location', 'SouthEastOutside');
title('Reaction Time Given Target is Present/Absent');
xlabel('Set Size');
ylabel('Reaction Time (s)');
set(gcf,'color','w');
set(gca,'Xtick',4:4:16);

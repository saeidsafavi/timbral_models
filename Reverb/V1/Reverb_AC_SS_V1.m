% This script adds the necessary paths for the Two!Ears Auditory Front-End
% and RT60 estimation.
% extraction framework and set up the needed pathes. Make sure to clear
% yourself the Matlab workspace, if that is necessary.
cd('wav files directory'); %location which contains all the wav files
[filenames, pathname, filterindex] = uigetfile( '*.wav', 'WAV-files (*.wav)', 'Pick a file', 'MultiSelect', 'on');
fid = fopen('outputfile.txt','w'); %name of the outfile file which will contain all the extracted features
for K = 1 : length(filenames)
  thisfullname = fullfile(pathname, filenames{K});
  [y,fs]=audioread(thisfullname);  % Reading Audio files
       
         parConf.mu_psi = -0.034;            % Defining parameters
         parConf.mu_psi_dip = -160.39*1e-3; % for estimation
 
         parConf.T_min = 63.1*1e-3;
 
         parConf.a_P_REV = 0.207; 
         parConf.b_P_REV = 21.4;
 
         parConf.a_P_CLA = 2.76; 
         parConf.b_P_CLA = 2.84;
 
         parConf.mu_ASW = 2e-2;      % or alpha1
         parConf.nu_ASW = 5.63e2;    % or beta1
 
         parConf.a_P_ASW = 2.41;
         parConf.b_P_ASW = 2.64;
 
         parConf.mu_LEV = 2.76e-2;   % or alpha2
         parConf.nu_LEV = 6.80e2;    % or beta2
 
         parConf.a_P_LEV = 1.17; 
         parConf.b_P_LEV = 2.20;
  [par, psi] = afeRAA(y, fs, parConf); % obtaining room acoustic aspects
  fprintf('\n RT estimation over time \n\n')

tic
[ rt_est_L, par ] = RT_estimation_my( y(:,1), fs ); %calculating the RT60 for
[ rt_est_R, par ] = RT_estimation_my( y(:,2), fs ); %left and right channels
toc
rtL_M=mean(rt_est_L);
rtR_M=mean(rt_est_R);
  fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n', filenames{K}(1:end-4), rtL_M, rtR_M, par.BL, par.sREV, par.FL, par.pClar, par.Llow, par.ITDf, par.pASW, par.ITDb, par.pLEV, par.sLEV);
end
fclose(fid);
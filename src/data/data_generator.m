clc, clear all, close all

% We will vary load values and perform load flows
EPISODES = 500;
PRINT_EVERY=10;
OUT_FILE='data_1_ieee9.csv';
data = [];
for i = 1:EPISODES
    k5 = rand(); % Percentage variation for load at bus 5
    k6 = rand(); % Percentage variation for load at bus 6
    k8 = rand(); % Percentage variation for load at bus 8
    
    % Perform loadflow
    LF = power_loadflow('ieee9', 'solve');
    
    if(LF.status ~= 1)
        % If load flow didn't converge, ignore episode
        continue;
    end
    
    % Extract results
    base = LF.basePower;
    nbus = size(LF.Ybus1, 1);
    
    Vbus = [LF.bus.Vbus];
    Vmod = abs(Vbus);
    Vangle = angle(Vbus);
    
    Sgen = [LF.bus.Sgen];
    Pgen = real(Sgen);
    Qgen = imag(Sgen);
    
    Pload = zeros(nbus,1);
    Qload = zeros(nbus,1);
    
    Prlcload = [LF.rlcload.P];
    Qrlcload = [LF.rlcload.Q];
    for bus = 1:nbus
        if(~isempty(LF.bus(bus).rlcload))
            idx = LF.bus(bus).rlcload;
            Pload(bus) = Prlcload(idx);
            Qload(bus) = Qrlcload(idx);
        end
    end
    
    Pload = Pload / base;
    Qload = Qload / base;
    
    data = [data; [Pload', Qload', Pgen, Qgen, Vmod, Vangle]]; %Pload, Qload, Pgen, Qgen, V, angle
    
    if mod(i, PRINT_EVERY) == 0
        fprintf("Finished episode %d\n", i);
    end
end

writematrix(data, OUT_FILE);
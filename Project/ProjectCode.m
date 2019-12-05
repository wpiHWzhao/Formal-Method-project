% the car has a length of 2 and a width of 1

ncol = 2;
nrow = 75;
tmax = 21;

States = zeros(ncol,nrow,tmax); %x_axis, y_axis, t_axis

% Initialization
V_A = zeros(ncol, nrow, ncol, nrow, tmax + 1);% t=22 here for initialization
V_H = zeros(ncol, nrow, ncol, nrow, tmax + 1);

for(t = tmax : -1 : 0)
    for (x_A = 0 : ncol)
        for (y_A = 0 : nrow)
            for (x_H = 0 : ncol)
                for (y_H = 0 : nrow)
                    for (i = 1 : 4) % Autonomous car actions: left, right, forward 2, stay. But it should be a backward recursion
                        if (i == 1) % Autonomous car stay
                            for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                if (j == 1)
                                    q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, t+1); % TODO: change here to 5 dimentional
                                elseif (j == 2)
                                    if (x_H + 1 <= nrow)
                                        q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, t+1);
                                    else
                                        continue
                                    end
                                elseif (j == 3)
                                    if (y_H - 1 >= 0)
                                        q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H - 1, t+1);
                                    else
                                        continue
                                    end
                                elseif (j == 4)
                                    if (y_H + 1 <= ncol)
                                        q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, t+1);
                                    else
                                        continue
                                    end
                                end
                            end
                        elseif (i == 2) % Autonomous car move forward
                            if (x_A + 1 <= nrow)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, t+1);
                                    elseif (j == 2)
                                        if (x_H + 1 <= nrow)
                                            q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, t+1);
                                        else
                                            continue
                                        end
                                    elseif (j == 3)
                                        if (y_H - 1 >= 0)
                                            q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H - 1, t+1);
                                        else
                                            continue
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= ncol)
                                            q_H = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, t+1);
                                        else
                                            continue
                                        end
                                    end
                                end
                            else
                                continue
                                
                        
                    end
                end
            end
        end
    end
    
end

function reward = reward_H(x_A, y_A, x_H, y_H)
if (abs(y_A - y_H) <= 3 && x_A == x_H)
    reward = -10000;
else
    reward = 0;
end
end

function reward = reward_A(x_A, y_A, x_H, y_H)
if (abs(y_A - y_H) <= 3 && x_A == x_H)
    reward = -10000;
else
    reward = 0;
end
end

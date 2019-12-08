% the car has a length of 2 and a width of 1
% Autonomous car has a forward speed of 2, and human dirver has a forward
% speed of 1
ncol = 2;
nrow = 10;
tmax = 10;

States = zeros(ncol,nrow,tmax); %x_axis, y_axis, t_axis

% Initialization
V_A = zeros(ncol, nrow, ncol, nrow, tmax + 1);% t=22 here for initialization
V_H = zeros(ncol, nrow, ncol, nrow, tmax + 1);

for(t = tmax : -1 : 0)
    for (x_A = 0 : ncol)
        for (y_A = 0 : nrow)
            for (x_H = 0 : ncol)
                for (y_H = 5 : nrow)
                    for (i = 1 : 4) % Autonomous car actions: left, right, forward 2, stay. But it should be a backward recursion
                        if (i == 1) % Autonomous car stay
                            for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                if (j == 1) % human driver stay
                                    q_H_stay_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1); % TODO: change here to 5 dimentional
                                elseif (j == 2) % human driver turn right
                                    if (x_H + 1 <= ncol)
                                        q_H_right_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A, y_A, t+1);
                                    else
                                        q_H_right_A_stay = 0;
                                    end
                                elseif (j == 3) % human driver turn left
                                    if (x_H - 1 >= 0)
                                        q_H_left_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A, y_A, t+1);
                                    else
                                        q_H_left_A_stay = 0;
                                    end
                                elseif (j == 4) % human driver foward
                                    if (y_H + 1 <= nrow)
                                        q_H_forward_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A, t+1);
                                    else
                                        q_H_forward_A_stay = 0;
                                    end
                                end
                            end
                            
                            % Simple Policy: If autonoumous car stay, the
                            % human driver will move forward. 
                            q_H_A_stay_star = q_H_forward_A_stay;
                            q_A_A_stay = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A, t+1);
                        elseif (i == 2) % Autonomous car move forward
                            if (y_A + 2 <= nrow)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H_stay_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A + 2, t+1); % TODO: change here to 5 dimentional
                                    elseif (j == 2)
                                        if (x_H + 1 <= ncol)
                                            q_H_right_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A, y_A + 2, t+1);
                                        else
                                            q_H_right_a_forward = 0;
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 0)
                                            q_H_left_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A, y_A + 2, t+1);
                                        else
                                            q_H_left_A_forward = 0;
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_forward_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A + 2, t+1);
                                        else
                                            q_H_forward_A_forward = 0;
                                        end
                                    end
                                end
                                % Simple policy: if autonomous car move foward and both cars are in the same lane,
                                % human driver would give up his lane.
                                if (x_A == x_H)
                                    if (x_A == 0) % Human should move to right
                                        q_H_A_forward_star = q_H_right_A_forward;
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H + 1, y_H, x_A, y_A + 2, t+1);
                                    else % Human should move to left
                                        q_H_A_forward_star = q_H_left_A_forward;
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H - 1, y_H, x_A, y_A + 2, t+1);
                                    end
                                else % both driver can move forward
                                    q_H_A_forward_star = q_H_forward_A_forward;
                                    q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A + 2, t+1);
                                end
                            else
                                q_A_A_forward = 0;
                            end
                            
                            
                        elseif (i == 3) % Autonomous car move left
                            if (x_A - 1 >= 0)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H_stay_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1); % TODO: change here to 5 dimentional
                                    elseif (j == 2)
                                        if (x_H + 1 <= ncol)
                                            q_H_right_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A - 1, y_A, t+1);
                                        else
                                            q_H_right_A_left = 0;
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 0)
                                            q_H_left_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A - 1, y_A, t+1);
                                        else
                                            q_H_left_A_left = 0;
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_forward_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A - 1, y_A, t+1);
                                        else
                                            q_H_forward_A_left = 0;
                                        end
                                    end
                                end
                                %Simple policy: if autonomous car move left,
                                %human driver would move to the right lane
                                q_H_A_left_star = q_H_right_A_left;
                                q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H + 1, y_H, x_A - 1, y_A, t+1);
                            else
                                q_A_A_left = 0;
                            end
                            
                        elseif (i==4) % Autonomous car move right
                            if (x_A + 1 <= ncol)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H_stay_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1); % TODO: change here to 5 dimentional
                                    elseif (j == 2)
                                        if (x_H + 1 <= ncol)
                                            q_H_right_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A + 1, y_A, t+1);
                                        else
                                            continue
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 0)
                                            q_H_left_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A + 1, y_A, t+1);
                                        else
                                            continue
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_foward_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A + 1, y_A, t+1);
                                        else
                                            continue
                                        end
                                    end
                                end
                                %Simple policy: if autonomous car move
                                %right, human driver would move to the left
                                %lane
                                q_H_A_right_star = q_H_left_A_right;
                                q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H - 1, y_H, x_A + 1, y_A, t+1);
                            else
                                q_A_A_right = 0;
                            end
                            
                                
                        
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

% the car has a length of 2 and a width of 1
% Autonomous car has a forward speed of 2, and human dirver has a forward
% speed of 1
ncol = 2;
nrow = 40; % if this value is changed, remember to change the value in the reward function.  
tmax = 21;

States = zeros(ncol,nrow,tmax); %x_axis, y_axis, t_axis

% Initialization
V_A = zeros(ncol, nrow, ncol, nrow, tmax + 1);% t=22 here for initialization
V_H = zeros(ncol, nrow, ncol, nrow, tmax + 1);
mj = 0;
for(t = tmax : -1 : 1)
    for (x_A = 1 : ncol)
        for (y_A = 1 : nrow)
            for (x_H = 1 : ncol)
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
                                        q_H_right_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    end
                                elseif (j == 3) % human driver turn left
                                    if (x_H - 1 >= 1)
                                        q_H_left_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A, y_A, t+1);
                                    else
                                        q_H_left_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    end
                                elseif (j == 4) % human driver foward
                                    if (y_H + 1 <= nrow)
                                        q_H_forward_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A, t+1);
                                    else
                                        q_H_forward_A_stay = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    end
                                end
                            end
                            
                            % Simple Policy: If autonoumous car stay, the
                            % human driver will move forward. 
                            q_H_A_stay_star = q_H_forward_A_stay;
                            if (y_H + 1 <= nrow)
                                q_A_A_stay = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A, t+1);
                            else
                                q_A_A_stay = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H , x_A, y_A, t+1);
                            end
                        elseif (i == 2) % Autonomous car move forward
                            if (y_A + 2 <= nrow)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H_stay_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A + 2, t+1); % TODO: change here to 5 dimentional
                                    elseif (j == 2)
                                        if (x_H + 1 <= ncol)
                                            q_H_right_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A, y_A + 2, t+1);
                                        else
                                            q_H_right_a_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A + 2, t+1);
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 1)
                                            q_H_left_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A, y_A + 2, t+1);
                                        else
                                            q_H_left_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A + 2, t+1);
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_forward_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A + 2, t+1);
                                        else
                                            q_H_forward_A_forward = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A + 2, t+1);
                                        end
                                    end
                                end
                                % Simple policy: if autonomous car move
                                % foward and both cars are in the same
                                % lane, and the human driver is in front of
                                % the autonomous car, human driver would 
                                % give up his lane.
                                if (x_A == x_H && y_H > y_A)
                                    if (x_A == 1) % Human should move to right
                                        q_H_A_forward_star = q_H_right_A_forward;
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H + 1, y_H, x_A, y_A + 2, t+1);
                                    else % Human should move to left
                                        q_H_A_forward_star = q_H_left_A_forward;
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H - 1, y_H, x_A, y_A + 2, t+1);
                                    end
                                else % both driver can move forward
                                    q_H_A_forward_star = q_H_forward_A_forward;
                                    if (y_H + 1 <= nrow)
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A + 2, t+1);
                                    else
                                        q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A, y_A + 2, t+1);
                                    end
                                end
                            else % if the autonomous car cannot move forward, then stay. 
                                if (y_H + 1 <= nrow)
                                    q_H_A_forward_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A, t+1);
                                    q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A, t+1);
                                else
                                    q_H_A_forward_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    q_A_A_forward = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A, y_A, t+1);
                                end
                            end
                            
                            
                        elseif (i == 3) % Autonomous car move left
                            if (x_A - 1 >= 1)
                                for (j = 1 : 4) % Human driver actions: left, right, forward, stay. But it should be a backward recursion
                                    if (j == 1)
                                        q_H_stay_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1); % TODO: change here to 5 dimentional
                                    elseif (j == 2)
                                        if (x_H + 1 <= ncol)
                                            q_H_right_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H + 1, y_H, x_A - 1, y_A, t+1);
                                        else
                                            q_H_right_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A - 1, y_A, t+1);
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 1)
                                            q_H_left_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A - 1, y_A, t+1);
                                        else
                                            q_H_left_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A - 1, y_A, t+1);
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_forward_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A - 1, y_A, t+1);
                                        else
                                            q_H_forward_A_left = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A - 1, y_A, t+1);
                                        end
                                    end
                                end
                                %Simple policy: if autonomous car move left,
                                %human driver would move to the right lane
                                q_H_A_left_star = q_H_right_A_left;
                                if (x_H + 1 <= ncol && y_H > y_A)
                                    q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H + 1, y_H, x_A - 1, y_A, t+1);
                                elseif (y_H + 1 <= nrow)
                                    q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A - 1, y_A, t+1);
                                else
                                    q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A - 1, y_A, t+1);
                                end
                            else
                                if (y_H + 1 <= nrow)
                                    q_H_A_left_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A, t+1);
                                    q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A, t+1);
                                else
                                    q_H_A_left_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    q_A_A_left = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A, y_A, t+1);
                                end
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
                                            q_H_right_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A + 1, y_A, t+1);
                                        end
                                    elseif (j == 3)
                                        if (x_H - 1 >= 1)
                                            q_H_left_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H - 1, y_H, x_A + 1, y_A, t+1);
                                        else
                                            q_H_left_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A + 1, y_A, t+1);
                                        end
                                    elseif (j == 4)
                                        if (y_H + 1 <= nrow)
                                            q_H_forward_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A + 1, y_A, t+1);
                                        else
                                            q_H_forward_A_right = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A + 1, y_A, t+1);
                                        end
                                    end
                                end
                                %Simple policy: if autonomous car move
                                %right,and if human driver is on the second lane, human would move to the left
                                %lane. Else human would keep going. 
                                if (x_H == 1)
                                    q_H_A_right_star = q_H_forward_A_right;
                                    if (y_H + 1<= nrow)
                                        q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A + 1, y_A, t+1);
                                    else
                                        q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A + 1, y_A, t+1);
                                    end
                                elseif (x_H == 2)
                                    q_H_A_right_star = q_H_left_A_right;
                                    q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H - 1, y_H, x_A + 1, y_A, t+1);
                                end
                            else
                                if (y_H + 1 <= nrow)
                                    q_H_A_right_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H + 1, x_A, y_A, t+1);
                                    q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H + 1, x_A, y_A, t+1);
                                else
                                    q_H_A_right_star = reward_H(x_A, y_A, x_H, y_H) + V_H(x_H, y_H, x_A, y_A, t+1);
                                    q_A_A_right = reward_A(x_A, y_A, x_H, y_H) + V_A(x_H, y_H, x_A, y_A, t+1);
                                end
                            end
                        end
                    end
                    %mj = mj + 1
                    q_A_star = max([q_A_A_stay, q_A_A_forward, q_A_A_left, q_A_A_right]);
                    V_A(x_A, y_A, x_H, y_H, t) = q_A_star;
                    if (q_A_star == q_A_A_stay)
                        V_H(x_A, y_A, x_H, y_H, t) = q_H_A_stay_star;
                    elseif(q_A_star == q_A_A_forward)
                        V_H(x_A, y_A, x_H, y_H, t) = q_H_A_forward_star;
                    elseif(q_A_star == q_A_A_left)
                        V_H(x_A, y_A, x_H, y_H, t) = q_H_A_left_star;
                    elseif(q_A_star == q_A_A_right)
                        V_H(x_A, y_A, x_H, y_H, t) = q_H_A_right_star;
                    end
                end
            end
        end
    end
end

heatmap(V_A(:, :, 1, 20, 12)); % t = 12, V_

function reward = reward_H(x_A, y_A, x_H, y_H)
nrow = 40; 
if (abs(y_A - y_H) <= 3 && x_A == x_H)
    reward_1 = -2000;
else
    reward_1 = 0;
end
reward_2 = 400 - 10* (nrow - y_H);
reward = reward_1 + reward_2;
end

function reward = reward_A(x_A, y_A, x_H, y_H)
nrow = 40;
if (abs(y_A - y_H) <= 3 && x_A == x_H)
    reward_1 = -2000;
else
    reward_1 = 0;
end
reward_2 = 400 - 10 * (nrow - y_A);
reward = reward_1 + reward_2;
end

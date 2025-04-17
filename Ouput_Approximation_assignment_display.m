function solve_gap_assignment_display()
    % Open the result file for writing
    resultFile = fopen('gap_assignment_result.txt', 'w');
    if resultFile == -1
        error('Error opening result file for writing.');
    end

    % Loop over all datasets
    for datasetIndex = 1:12
        fileName = sprintf('gap%d.txt', datasetIndex);
        fileId = fopen(fileName, 'r');
        if fileId == -1
            fprintf(resultFile, 'Error opening file %s.\n', fileName);
            continue;
        end

        % Read number of problems
        numProblems = fscanf(fileId, '%d', 1);

        fprintf(resultFile, '\n==========================================\n');
        fprintf(resultFile, '   Processing Dataset: GAP %d\n', datasetIndex);
        fprintf(resultFile, '==========================================\n');

        for problemIndex = 1:numProblems
            numServers = fscanf(fileId, '%d', 1); % servers
            numUsers = fscanf(fileId, '%d', 1);   % users

            costMatrix = fscanf(fileId, '%d', [numUsers, numServers])'; % cost numServers x numUsers
            resourceMatrix = fscanf(fileId, '%d', [numUsers, numServers])'; % resource numServers x numUsers
            serverCapacities = fscanf(fileId, '%d', [numServers, 1]);  % capacity numServers x 1

            % Solve using greedy method
            assignmentMatrix = greedy_gap_assignment(numServers, numUsers, costMatrix, resourceMatrix, serverCapacities);
            totalCost = sum(sum(costMatrix .* assignmentMatrix));
            totalAssignedUsers = sum(sum(assignmentMatrix)); % total assignments (should be ≤ numUsers)

            % Print results to the console
            resultStr = sprintf('Problem %2d | Servers: %2d | Users: %2d | Total Cost: %6d | Assigned Users: %2d/%2d\n', ...
                problemIndex, numServers, numUsers, round(totalCost), totalAssignedUsers, numUsers);
            fprintf(resultStr); % Print to console

            % Write results to the file
            fprintf(resultFile, '%s', resultStr);
        end

        fclose(fileId); % Close the dataset file
    end

    fclose(resultFile); % Close the result file after writing all results
end

function assignmentMatrix = greedy_gap_assignment(numServers, numUsers, costMatrix, resourceMatrix, serverCapacities)
    assignmentMatrix = zeros(numServers, numUsers);           % assignment matrix
    remainingCapacities = serverCapacities(:);                % copy of server capacities

    for userIndex = 1:numUsers  % For each user
        bestCost = Inf;
        bestServer = -1;
        for serverIndex = 1:numServers  % For each server
            if resourceMatrix(serverIndex, userIndex) <= remainingCapacities(serverIndex) && costMatrix(serverIndex, userIndex) < bestCost
                bestCost = costMatrix(serverIndex, userIndex);
                bestServer = serverIndex;
            end
        end

        if bestServer > 0
            assignmentMatrix(bestServer, userIndex) = 1;
            remainingCapacities(bestServer) = remainingCapacities(bestServer) - resourceMatrix(bestServer, userIndex);
        end
    end
end

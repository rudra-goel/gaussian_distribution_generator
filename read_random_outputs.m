clc; close all;

gen_plots = true;
print_stats = true;

input_filename = 'random_number_outputs.txt';

bin_vals = readlines(input_filename);
vals_base10 = bin2dec(bin_vals);
normalized = vals_base10 / max(vals_base10);


if print_stats
    fprintf('\n--- Statistics ---\n');
    fprintf('Number of values: %d\n', length(normalized));
    fprintf('Minimum value: %.0f\n', min(normalized));
    fprintf('Maximum value: %.0f\n', max(normalized));
    fprintf('Mean value: %.2f\n', mean(normalized));
    fprintf('Standard deviation: %.2f\n', std(normalized));
    
        
        
end

if gen_plots
    % Create a simple histogram
    figure('Position', [100, 500, 1200, 750]);
    subplot(2, 1, 1);
    histogram(normalized, 50);
    title(strcat('Distribution of Random Number Values (', num2str(length(normalized)), ' Samples)'));
    xlabel('Decimal Value');
    ylabel('Frequency');
    grid on;
    

    % Create time series plot
    subplot(2, 1, 2);
    plot(normalized);
    title('Random Number Sequence');
    xlabel('Sample Number');
    ylabel('Decimal Value');
    grid on;
end
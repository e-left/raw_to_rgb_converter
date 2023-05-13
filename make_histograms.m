function make_histograms(image, title, bayertype, method)
    % make_histograms: generate r, g, b and combined 
    % histogram for an image
    complete_title = sprintf("%s, bayer pattern = %s, demosaication method = %s", ...\
        title, bayertype, method);
    
    red_data = reshape(image(:, :, 1), [], 1);
    green_data = reshape(image(:, :, 2), [], 1);
    blue_data = reshape(image(:, :, 3), [], 1);
    
    figure("Name", complete_title, 'Units', 'Normalized', 'OuterPosition', [0 0 0.6 0.6]);
    sgtitle("Color histograms")
    subplot(2, 2, 1);
    histogram(red_data, "EdgeColor", "red", "EdgeAlpha", 0.2, "FaceColor", "red", "FaceAlpha", 0.6);
    xlabel("Value");
    ylabel("Count");
    xlim([0, 1]);

    subplot(2, 2, 2);
    histogram(green_data, "EdgeColor", "green", "EdgeAlpha", 0.2, "FaceColor", "green", "FaceAlpha", 0.6);
    xlabel("Value");
    ylabel("Count");
    xlim([0, 1]);

    subplot(2, 2, 3);
    histogram(blue_data, "EdgeColor", "blue", "EdgeAlpha", 0.2, "FaceColor", "blue", "FaceAlpha", 0.6);
    xlabel("Value");
    ylabel("Count");
    xlim([0, 1]);

    subplot(2, 2, 4);
    histogram(red_data, "DisplayStyle", "stairs", "EdgeColor", "red");
    hold on;
    histogram(green_data, "DisplayStyle", "stairs", "EdgeColor", "green");
    histogram(blue_data, "DisplayStyle", "stairs", "EdgeColor", "blue");
    xlabel("Value");
    ylabel("Count");
    xlim([0, 1]);

    saveas(gcf, sprintf("%s_%s_%s_histograms.png", title, bayertype, method));
end


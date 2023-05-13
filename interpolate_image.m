function rgb = interpolate_image(raw_image, bayertype, method, M, N)
    % interpolate_image: transforms image from white balanced
    % single channel raw to rgb, depending on bayertype and method

    N0 = size(raw_image, 1);
    M0 = size(raw_image, 2);

    x_ratio = N0 / N;
    y_ratio = M0 / M;

    rgb = zeros([N, M, 3]);

    % if method == "nearest"
    % 
    %     % nearest neighboor method

    switch bayertype
        case "RGGB"
            % calculate coordinates
            top_left_x = 1:2:N0;
            top_left_y = 1:2:M0;
            top_right_x = 1:2:N0;
            top_right_y = 2:2:M0;
            bottom_left_x = 2:2:N0;
            bottom_left_y = 1:2:M0;
            bottom_right_x = 2:2:N0;
            bottom_right_y = 2:2:M0;

            % prepare resampling indexes
            r_0 = raw_image(top_left_x, top_left_y);
            g1_0 = raw_image(top_right_x, top_right_y);
            g2_0 = raw_image(bottom_left_x, bottom_left_y);
            b_0 = raw_image(bottom_right_x, bottom_right_y);
            rescale_x = ceil(1:x_ratio:N0);
            rescale_y = ceil(1:y_ratio:M0);
            resample_x = rescale_x(1:(N / 2));
            resample_y = rescale_y(1:(M / 2));

            % clamp from above
            resample_x = min(resample_x, N0 / 2);
            resample_y = min(resample_y, M0 / 2);

            % resample
            r = r_0(resample_x, resample_y);
            g1 = g1_0(resample_x, resample_y);
            g2 = g2_0(resample_x, resample_y);
            b = b_0(resample_x, resample_y);

            if method == "nearest"

                % top left
                rgb(1:2:end, 1:2:end, 1) = r;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = b;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = r;
                rgb(1:2:end, 2:2:end, 2) = g1;
                rgb(1:2:end, 2:2:end, 3) = b;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = r;
                rgb(2:2:end, 1:2:end, 2) = g2;
                rgb(2:2:end, 1:2:end, 3) = b;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = r;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = b;
            
            elseif method == "linear"

                % pad the arrays with zeros around
                r_padded = padarray(r, [1 1], 0, "both");
                g1_padded = padarray(g1, [1 1], 0, "both");
                g2_padded = padarray(g2, [1 1], 0, "both");
                b_padded = padarray(b, [1 1], 0, "both");

                % top left
                rgb(1:2:end, 1:2:end, 1) = r;
                rgb(1:2:end, 1:2:end, 2) = (g1_padded(2:(end - 1), 1:(end - 2)) ...\
                    + g1_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g2_padded(1:(end - 2), 2:(end - 1)) + g2_padded(2:(end - 1), 2:(end - 1))) / 4;
                rgb(1:2:end, 1:2:end, 3) = (b_padded(1:(end - 2), 1:(end - 2)) ...
                    + b_padded(1:(end - 2), 2:(end - 1)) ...\
                    + b_padded(2:(end - 1), 1:(end - 2)) + b_padded(2:(end - 1), 2:(end - 1))) / 4;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = (r_padded(2:(end - 1), 2:(end - 1)) + r_padded(2:(end - 1), 3:end)) / 2;
                rgb(1:2:end, 2:2:end, 2) = g1;
                rgb(1:2:end, 2:2:end, 3) = (b_padded(1:(end - 2), 2:(end - 1)) + b_padded(2:(end - 1), 2:(end - 1))) / 2;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = (r_padded(2:(end - 1), 2:(end - 1)) + r_padded(3:end, 2:(end - 1))) / 2;
                rgb(2:2:end, 1:2:end, 2) = g2;
                rgb(2:2:end, 1:2:end, 3) = (b_padded(2:(end - 1), 1:(end - 2)) + b_padded(2:(end - 1), 2:(end - 1))) / 2;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = (r_padded(2:(end - 1), 2:(end - 1)) ...
                    + r_padded(2:(end - 1), 3:end) ...\
                    + r_padded(3:end, 2:(end - 1)) + r_padded(3:end, 3:end)) / 4;
                rgb(2:2:end, 2:2:end, 2) = (g2_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g2_padded(2:(end - 1), 3:end) ...\
                    + g1_padded(2:(end - 1), 2:(end - 1)) + g1_padded(3:end, 2:(end - 1))) / 4;
                rgb(2:2:end, 2:2:end, 3) = b;

            end

        case "BGGR"

            % calculate coordinates
            top_left_x = 1:2:N0;
            top_left_y = 1:2:M0;
            top_right_x = 1:2:N0;
            top_right_y = 2:2:M0;
            bottom_left_x = 2:2:N0;
            bottom_left_y = 1:2:M0;
            bottom_right_x = 2:2:N0;
            bottom_right_y = 2:2:M0;

            % prepare resampling indexes
            b_0 = raw_image(top_left_x, top_left_y);
            g1_0 = raw_image(top_right_x, top_right_y);
            g2_0 = raw_image(bottom_left_x, bottom_left_y);
            r_0 = raw_image(bottom_right_x, bottom_right_y);
            rescale_x = ceil(1:x_ratio:N0);
            rescale_y = ceil(1:y_ratio:M0);
            resample_x = rescale_x(1:(N / 2));
            resample_y = rescale_y(1:(M / 2));

            % clamp from above
            resample_x = min(resample_x, N0 / 2);
            resample_y = min(resample_y, M0 / 2);

            % resample
            r = r_0(resample_x, resample_y);
            g1 = g1_0(resample_x, resample_y);
            g2 = g2_0(resample_x, resample_y);
            b = b_0(resample_x, resample_y);

            if method == "nearest"

                % top left
                rgb(1:2:end, 1:2:end, 1) = r;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = b;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = r;
                rgb(1:2:end, 2:2:end, 2) = g1;
                rgb(1:2:end, 2:2:end, 3) = b;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = r;
                rgb(2:2:end, 1:2:end, 2) = g2;
                rgb(2:2:end, 1:2:end, 3) = b;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = r;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = b;
            
            elseif method == "linear"

                % pad the arrays with zeros around
                r_padded = padarray(r, [1 1], 0, "both");
                g1_padded = padarray(g1, [1 1], 0, "both");
                g2_padded = padarray(g2, [1 1], 0, "both");
                b_padded = padarray(b, [1 1], 0, "both");

                % top left
                rgb(1:2:end, 1:2:end, 1) = (r_padded(1:(end - 2), 1:(end - 2)) ...
                    + r_padded(1:(end - 2), 2:(end - 1)) ...\
                    + r_padded(2:(end - 1), 1:(end - 2)) + r_padded(2:(end - 1), 2:(end - 1))) / 4;
                rgb(1:2:end, 1:2:end, 2) = (g1_padded(2:(end - 1), 1:(end - 2)) ...\
                    + g1_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g2_padded(1:(end - 2), 2:(end - 1)) + g2_padded(2:(end - 1), 2:(end - 1))) / 4;
                rgb(1:2:end, 1:2:end, 3) = b;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = (r_padded(1:(end - 2), 2:(end - 1)) + r_padded(2:(end - 1), 2:(end - 1))) / 2;
                rgb(1:2:end, 2:2:end, 3) = (b_padded(2:(end - 1), 2:(end - 1)) + b_padded(2:(end - 1), 3:end)) / 2;
                rgb(1:2:end, 2:2:end, 2) = g1;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = (r_padded(2:(end - 1), 1:(end - 2)) + r_padded(2:(end - 1), 2:(end - 1))) / 2;
                rgb(2:2:end, 1:2:end, 3) = (b_padded(2:(end - 1), 2:(end - 1)) + b_padded(3:end, 2:(end - 1))) / 2;
                rgb(2:2:end, 1:2:end, 2) = g2;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = r;
                rgb(2:2:end, 2:2:end, 2) = (g1_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g1_padded(3:end, 2:(end - 1)) ...\
                    + g2_padded(2:(end - 1), 2:(end - 1)) + g2_padded(2:(end - 1), 3:end)) / 4;
                rgb(2:2:end, 2:2:end, 3) = (b_padded(2:(end - 1), 2:(end - 1)) ...
                    + b_padded(2:(end - 1), 3:end) ...\
                    + b_padded(3:end, 2:(end - 1)) + b_padded(3:end, 3:end)) / 4;

            end

        case "GRBG"

            % calculate coordinates
            top_left_x = 1:2:N0;
            top_left_y = 1:2:M0;
            top_right_x = 1:2:N0;
            top_right_y = 2:2:M0;
            bottom_left_x = 2:2:N0;
            bottom_left_y = 1:2:M0;
            bottom_right_x = 2:2:N0;
            bottom_right_y = 2:2:M0;

            % prepare resampling indexes
            g1_0 = raw_image(top_left_x, top_left_y);
            r_0 = raw_image(top_right_x, top_right_y);
            b_0 = raw_image(bottom_left_x, bottom_left_y);
            g2_0 = raw_image(bottom_right_x, bottom_right_y);
            rescale_x = ceil(1:x_ratio:N0);
            rescale_y = ceil(1:y_ratio:M0);
            resample_x = rescale_x(1:(N / 2));
            resample_y = rescale_y(1:(M / 2));

            % clamp from above
            resample_x = min(resample_x, N0 / 2);
            resample_y = min(resample_y, M0 / 2);

            % resample
            r = r_0(resample_x, resample_y);
            g1 = g1_0(resample_x, resample_y);
            g2 = g2_0(resample_x, resample_y);
            b = b_0(resample_x, resample_y);

            if method == "nearest"

                % top left
                rgb(1:2:end, 1:2:end, 1) = r;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = b;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = r;
                rgb(1:2:end, 2:2:end, 2) = g1;
                rgb(1:2:end, 2:2:end, 3) = b;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = r;
                rgb(2:2:end, 1:2:end, 2) = g2;
                rgb(2:2:end, 1:2:end, 3) = b;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = r;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = b;
            
            elseif method == "linear"

                % pad the arrays with zeros around
                r_padded = padarray(r, [1 1], 0, "both");
                g1_padded = padarray(g1, [1 1], 0, "both");
                g2_padded = padarray(g2, [1 1], 0, "both");
                b_padded = padarray(b, [1 1], 0, "both");

                % top left
                rgb(1:2:end, 1:2:end, 1) = (r_padded(2:(end - 1), 1:(end - 2)) + r_padded(2:(end - 1), 2:(end - 1))) / 2;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = (b_padded(1:(end - 2), 2:(end - 1)) + b_padded(2:(end - 1), 2:(end - 1))) / 2;
                
                % top right
                rgb(1:2:end, 2:2:end, 1) = r;
                rgb(1:2:end, 2:2:end, 2) = (g1_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g1_padded(2:(end - 1), 3:end) ...\
                    + g2_padded(1:(end - 2), 2:(end - 1)) + g2_padded(2:(end - 1), 2:(end - 1))) / 4;
                rgb(1:2:end, 2:2:end, 3) = (b_padded(1:(end - 2), 2:(end - 1)) ...
                    + b_padded(1:(end - 2), 3:end) ...\
                    + b_padded(2:(end - 1), 2:(end - 1)) + b_padded(2:(end - 1), 3:end)) / 4;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = (r_padded(2:(end - 1), 1:(end - 2)) ...
                    + r_padded(2:(end - 1), 2:(end - 1)) ...\
                    + r_padded(3:end, 1:(end - 2)) + r_padded(3:end, 2:(end - 1))) / 4;
                rgb(2:2:end, 1:2:end, 2) = (g2_padded(2:(end - 1), 1:(end - 2)) ...\
                    + g2_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g1_padded(2:(end - 1), 2:(end - 1)) + g1_padded(3:end, 2:(end - 1))) / 4;
                rgb(2:2:end, 1:2:end, 3) = b;               
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = (r_padded(2:(end - 1), 2:(end - 1)) + r_padded(3:end, 2:(end - 1))) / 2;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = (b_padded(2:(end - 1), 2:(end - 1)) + b_padded(2:(end - 1), 3:end)) / 2;

            end            

        case "GBRG"

            % calculate coordinates
            top_left_x = 1:2:N0;
            top_left_y = 1:2:M0;
            top_right_x = 1:2:N0;
            top_right_y = 2:2:M0;
            bottom_left_x = 2:2:N0;
            bottom_left_y = 1:2:M0;
            bottom_right_x = 2:2:N0;
            bottom_right_y = 2:2:M0;

            % prepare resampling indexes
            g1_0 = raw_image(top_left_x, top_left_y);
            b_0 = raw_image(top_right_x, top_right_y);
            r_0 = raw_image(bottom_left_x, bottom_left_y);
            g2_0 = raw_image(bottom_right_x, bottom_right_y);
            rescale_x = ceil(1:x_ratio:N0);
            rescale_y = ceil(1:y_ratio:M0);
            resample_x = rescale_x(1:(N / 2));
            resample_y = rescale_y(1:(M / 2));

            % clamp from above
            resample_x = min(resample_x, N0 / 2);
            resample_y = min(resample_y, M0 / 2);

            % resample
            r = r_0(resample_x, resample_y);
            g1 = g1_0(resample_x, resample_y);
            g2 = g2_0(resample_x, resample_y);
            b = b_0(resample_x, resample_y);

            if method == "nearest"

                % top left
                rgb(1:2:end, 1:2:end, 1) = r;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = b;
    
                % top right
                rgb(1:2:end, 2:2:end, 1) = r;
                rgb(1:2:end, 2:2:end, 2) = g1;
                rgb(1:2:end, 2:2:end, 3) = b;
    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = r;
                rgb(2:2:end, 1:2:end, 2) = g2;
                rgb(2:2:end, 1:2:end, 3) = b;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = r;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = b;
            
            elseif method == "linear"

                % pad the arrays with zeros around
                r_padded = padarray(r, [1 1], 0, "both");
                g1_padded = padarray(g1, [1 1], 0, "both");
                g2_padded = padarray(g2, [1 1], 0, "both");
                b_padded = padarray(b, [1 1], 0, "both");

                % top left
                rgb(1:2:end, 1:2:end, 1) = (r_padded(1:(end - 2), 2:(end - 1)) + r_padded(2:(end - 1), 2:(end - 1))) / 2;
                rgb(1:2:end, 1:2:end, 2) = g1;
                rgb(1:2:end, 1:2:end, 3) = (b_padded(2:(end - 1), 1:(end - 2)) + b_padded(2:(end - 1), 2:(end - 1))) / 2;
                
                % top right
                rgb(1:2:end, 2:2:end, 1) = (r_padded(2:(end - 1), 1:(end - 2)) ...
                    + r_padded(2:(end - 1), 2:(end - 1)) ...\
                    + r_padded(3:end, 1:(end - 2)) + r_padded(3:end, 2:(end - 1))) / 4;
                rgb(1:2:end, 2:2:end, 2) = (g1_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g1_padded(2:(end - 1), 3:end) ...\
                    + g2_padded(1:(end - 2), 2:(end - 1)) + g2_padded(2:(end - 1), 2:(end - 1))) / 4;
                
                rgb(1:2:end, 2:2:end, 3) = b;               

    
                % bottom left
                rgb(2:2:end, 1:2:end, 1) = r;
                rgb(2:2:end, 1:2:end, 2) = (g2_padded(2:(end - 1), 1:(end - 2)) ...\
                    + g2_padded(2:(end - 1), 2:(end - 1)) ...\
                    + g1_padded(2:(end - 1), 2:(end - 1)) + g1_padded(3:end, 2:(end - 1))) / 4;
                rgb(2:2:end, 1:2:end, 3) = (b_padded(1:(end - 2), 2:(end - 1)) ...
                    + b_padded(1:(end - 2), 3:end) ...\
                    + b_padded(2:(end - 1), 2:(end - 1)) + b_padded(2:(end - 1), 3:end)) / 4;
                
                % bottom right
                rgb(2:2:end, 2:2:end, 1) = (r_padded(2:(end - 1), 2:(end - 1)) + r_padded(3:end, 2:(end - 1))) / 2;
                rgb(2:2:end, 2:2:end, 2) = g2;
                rgb(2:2:end, 2:2:end, 3) = (b_padded(2:(end - 1), 2:(end - 1)) + b_padded(2:(end - 1), 3:end)) / 2;

            end            

    end

end


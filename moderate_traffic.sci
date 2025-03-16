// Step 1: Load an RGB image
img = imread("moderate.png");
ref_img = imread("less.png");

// Step 2: Convert to grayscale
// user image
if size(img, 3) == 3 then
    gray_img = rgb2gray(img);
else
    gray_img = img; // If already grayscale, no conversion
end
// reference image
if size(ref_img, 3) == 3 then
    gray_img_ref = rgb2gray(ref_img);
else
    gray_img_ref = ref_img; // If already grayscale, no conversion
end

// Step 3: Resize the image to desired dimensions
target_height = 300; // Desired height
target_width = 400;  // Desired width
// user image
resized_img = imresize(gray_img, [target_height, target_width]);

// reference image
resized_img_ref = imresize(gray_img_ref, [target_height, target_width]);

// Step 4: Apply image enhancement using Power-Law Transformation
c = 1; // Constant multiplier
gamma = 4.2; // Gamma value for enhancement
// user image
resized_img = double(resized_img) / 255; // Normalize pixel values to [0, 1]
enhanced_img = c * (resized_img .^ gamma); // Apply Power-Law Transformation

// Scale back to [0, 255] and convert to uint8
enhanced_img = uint8(enhanced_img * 255);

//reference image
resized_img_ref = double(resized_img_ref) / 255; // Normalize pixel values to [0, 1]
enhanced_img_ref = c * (resized_img_ref .^ gamma); // Apply Power-Law Transformation

// Scale back to [0, 255] and convert to uint8
enhanced_img_ref = uint8(enhanced_img_ref * 255);

// Step 5: Apply edge detection using canny edge detection
method = "canny"; 
thresh = 0.2;       // Threshold value (0 to 1)
direction = "both"; // Edge direction ('horizontal', 'vertical', or 'both')

// Apply the edge detection function on user image
edges = edge(enhanced_img, method, thresh, direction);

// Apply the edge detection function on reference image
ref_edges = edge(enhanced_img_ref, method, thresh, direction);


// Step 6: Perform Image Matching
// Compute the absolute difference between the edge-detected images
pixel_diff = abs(edges - ref_edges);
// Count mismatched pixels
mismatched_pixels = sum(pixel_diff); // Count pixels with any difference
// Calculate the total number of pixels
total_pixels = size(edges, 1) * size(edges, 2);
// Compute the matching percentage
matching_percentage = (1 - (mismatched_pixels / total_pixels)) * 100;

// Step 7: Determine Traffic Situation Based on Matching Percentage
if matching_percentage > 85 then
    traffic_condition = "less traffic"
    disp("Less Traffic Situation");
    traffic_stops_time = 2; // Seconds
    pedestrian_walk_time = 20; // Seconds
elseif matching_percentage >= 70 then
    traffic_condition = "moderate traffic"
    disp("Moderate Traffic Situation");
    traffic_stops_time = 10; // Seconds
    pedestrian_walk_time = 20; // Seconds
else
    disp("Heavy Traffic Situation");
    traffic_condition = "more traffic"
    traffic_stops_time = 20; // Seconds
    pedestrian_walk_time = 20; // Seconds
end

// Step 8: Display Traffic Light Output
disp("Traffic Stops in: " + string(traffic_stops_time) + " seconds");
disp("Pedestrian Walk Time: " + string(pedestrian_walk_time) + " seconds");

// Step 9: Visualize Results
figure();
subplot(2, 2, 1);
imshow(img);
title("Original Image");

subplot(2, 2, 2);
imshow(gray_img);
title("Grayscale Image");

subplot(2, 2, 3);
imshow(enhanced_img);
title("Enhanced Image");

subplot(2, 2, 4);
imshow(edges);
title("Edge Detection");

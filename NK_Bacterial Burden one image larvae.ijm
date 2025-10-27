// ========== USER CONFIGURATION ==========
imageDir = "X\\";
masterResults = "Y";
masterSummary = "Z";
// ========================================

list = getFileList(imageDir);

for (i = 0; i < list.length; i++) {
    filename = list[i];

    // Only process .tif files
    if (!endsWith(filename, ".tif")) continue;

    fullPath = imageDir + filename;
    open(fullPath);
    originalName = getTitle();

    // --- Ask user to draw ROI ---
    waitForUser("Draw a shape around the ROI for: " + originalName + "\nThen click OK to analyze.");

    // Save and clear the ROI
    roiManager("reset");
    roiManager("Add");
    roiManager("Select", 0);
    roiManager("Deselect");

    // --- Threshold & Convert to Mask ---
    resetMinAndMax();
    setThreshold(a, b, "raw");
    setOption("BlackBackground", true);
    run("Convert to Mask");

    // Re-select ROI
    roiManager("Select", 0);

    // --- Analyze Particles ---
    run("Set Measurements...", "area mean standard min centroid center perimeter bounding shape feret's integrated display redirect=None decimal=3");
    run("Analyze Particles...", 
        "size=0-Infinity circularity=0.00-1.00 show=Nothing display clear summarize add in_situ pixel");

    // --- Save Results Table ---
    if (isOpen("Results")) {
        selectWindow("Results");

        nRows = nResults;
        for (r = 0; r < nRows; r++) {
            setResult("Filename", r, originalName);
        }

        tempResults = imageDir + "temp_results.csv";
        saveAs("Results", tempResults);
        run("Close");
        appendToFile(masterResults, tempResults);
        File.delete(tempResults);
    }

    // --- Save Summary Table ---
    if (isOpen("Summary")) {
        selectWindow("Summary");

        tempSummary = imageDir + "temp_summary.csv";
        saveAs("Results", tempSummary);
        run("Close");

        text = File.openAsString(tempSummary);
        lines = split(text, "\n");
        newText = "";

        for (j = 0; j < lines.length; j++) {
            line = lines[j];
            if (lengthOf(line) > 0) {
                newText += originalName + "," + line + "\n";
            }
        }

        File.saveString(newText, tempSummary);
        appendToFile(masterSummary, tempSummary);
        File.delete(tempSummary);
    }

    // Clean up
    roiManager("reset");
    if (isOpen("ROI Manager")) {
        selectWindow("ROI Manager");
        run("Close");
    }

    close(); // Close image
    print("✔ Processed: " + originalName);
}

// -------- Helper Function --------
function appendToFile(masterFile, tempFile) {
    content = File.openAsString(tempFile);
    if (!File.exists(masterFile)) {
        File.copy(tempFile, masterFile); // First time: copy full file
    } else {
        lines = split(content, "\n");
        for (k = 1; k < lines.length; k++) { // Skip header
            if (lengthOf(lines[k]) > 0) {
                File.append(lines[k] + "\n", masterFile);
            }
        }
    }
}

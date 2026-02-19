#!/bin/bash
# Script to set up the attendance tracker project directory and handle interruptions carefully.

# Prompt user for name to create personalized directory
read -p "Please enter your name: " NAME_ID

MAIN_DIR="attendance_tracker_${NAME_ID}"

# Function to handle interrupt signals (Ctrl+C)
cleanup() {
    echo ""
    echo "WARNING: Interrupt detected (Ctrl+C)."

    if [ -d "$MAIN_DIR" ]; then
        ARCHIVE_NAME="${MAIN_DIR}_archive.tar.gz"
        echo "Archiving project..."

        tar -czf "$ARCHIVE_NAME" "$MAIN_DIR"

        rm -rf "$MAIN_DIR"

        echo "[✓]Project archived as $ARCHIVE_NAME and incomplete directory removed."
    else
        echo "WARNING: No directory found to archive."
    fi

    exit 1
}

trap cleanup SIGINT
# Added a health check function to verify environment setup
health_check() {
    echo ""
    echo "--- Performing Environment Health Check ---"

    # Check Python3
    if command -v python3 &> /dev/null; then
        python3 --version
        echo "[✓] Python3 is installed."
    else
        echo "[!] WARNING: python3 is not installed. The application may not run."
    fi

    # Verify directory structure
    if [ -d "$MAIN_DIR" ] && \
       [ -f "$MAIN_DIR/attendance_checker.py" ] && \
       [ -d "$MAIN_DIR/Helpers" ] && \
       [ -f "$MAIN_DIR/Helpers/config.json" ] && \
       [ -f "$MAIN_DIR/Helpers/assets.csv" ] && \
       [ -d "$MAIN_DIR/reports" ] && \
       [ -f "$MAIN_DIR/reports/reports.log" ]; then
        echo "[✓] Directory structure verified successfully."
    else
        echo "[!] WARNING: Directory structure is incomplete."
    fi

    echo "--- Health Check Complete ---"
}

# Script to check if the directory already exists
if [ -d "$MAIN_DIR" ]; then
    echo "{[!] Directory '$MAIN_DIR' already exists. Please choose a different name.}"
    exit 1
else
    mkdir "$MAIN_DIR"
    echo "{[✓] Directory '$MAIN_DIR' created successfully.}"
fi

# Script to create subdirectories 
mkdir -p "$MAIN_DIR/Helpers"
mkdir -p "$MAIN_DIR/reports"

echo "{[✓] Project directory structure created.}"

# Copy files to the appropriate locations
cp attendance_checker.py "$MAIN_DIR/"
cp config.json "$MAIN_DIR/Helpers/"
cp assets.csv "$MAIN_DIR/Helpers/"
cp reports.log "$MAIN_DIR/reports/"

echo "{[✓] Files copied successfully.}"
# Make Python script executable
    if [ -f "$MAIN_DIR/attendance_checker.py" ]; then
        chmod +x "$MAIN_DIR/attendance_checker.py"
        echo "Made attendance_checker.py executable"
    fi

echo "Setup complete!"

#prompt user for configuration updates

read -p "Do you want to update the configuration file (config.json)? (yes/no) " REPLY

if [ "$REPLY" == "yes" ]; then
    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure
   
 
    # Validate numeric input and logical range
if [[ "$warning" =~ ^[0-9]+$ ]] && [[ "$failure" =~ ^[0-9]+$ ]]; then

    if (( warning > 0 && warning <= 100 )) && \
       (( failure >= 0 && failure < warning )); then

sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" "$MAIN_DIR/Helpers/config.json"
sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" "$MAIN_DIR/Helpers/config.json"
        
        echo "[✓] Thresholds updated successfully."

    else
        echo "Invalid range!"
        echo "Rules:"
        echo "- Warning must be between 1 and 100"
        echo "- Failure must be between 0 and (less than Warning)"
        echo "Keeping default values."
    fi

else
    echo "Invalid input. Thresholds must be numeric."
fi

fi
health_check
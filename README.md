# deploy_agent_akotet27

A shell script that automates the setup of a Student Attendance Tracker workspace.

## Requirements

- Bash shell
- Python 3
- Source files in the same directory as `setup_project.sh`: `attendance_checker.py`, `assets.csv`, `config.json`, `reports.log`

## How to Run

```bash
bash setup_project.sh
```

Enter a name when prompted — this creates `attendance_tracker_{name}/` with the required structure. You will then be asked if you want to update the warning (default 75%) and failure (default 50%) thresholds.

## Running the Attendance Checker

```bash
cd attendance_tracker_{name}
python3 attendance_checker.py
cat reports/reports.log
```

## Triggering the Archive Feature

Press `Ctrl+C` at any point while the script is running. It will automatically archive the incomplete directory as `attendance_tracker_{name}_archive.tar.gz` and delete the incomplete folder to keep the workspace clean.

## Environment Health Check

Runs automatically at the end of every setup. To run it standalone:

```bash
bash setup_project.sh --check
```

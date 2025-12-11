#!/data/data/com.termux/files/usr/bin/bash

AUTOMATION_DIR="$HOME/termux-automation"
INTERVAL_MS=$((15 * 60 * 1000))   # 15 minutes in milliseconds

start_jobs() {
    echo "[+] Starting all scripts in $AUTOMATION_DIR"
    
    for script in "$AUTOMATION_DIR"/*.sh; do
        # Skip this manage script itself
        if [[ "$(basename "$script")" == "manage-jobs.sh" ]]; then
            continue
        fi

        echo "[+] Scheduling: $script (Job ID: $job_id)"

        termux-job-scheduler \
            --script "$script" \
            --period-ms "$INTERVAL_MS" \

    done
}

stop_jobs() {
    echo "[+] Stopping all scheduled jobs..."

    pending=$(termux-job-scheduler --pending | grep "Job" | wc -l)

    if [[ "$pending" -eq 0 ]]; then
        echo "[-] No jobs to cancel."
        return
    fi

    for id in $(termux-job-scheduler --pending | grep "Job" | awk '{print $3}' | sed 's/://'); do
        echo "[+] Cancelling job id $id"
        termux-job-scheduler --cancel --job-id "$id"
    done
}

case "$1" in
    start)
        start_jobs
        ;;
    stop)
        stop_jobs
        ;;
    restart)
        stop_jobs
        sleep 1
        start_jobs
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        ;;
esac

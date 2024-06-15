#!/bin/bash

echo "Sleep for 90 seconnds to let cloud-init finish"
sleep 90 

# Remote host details
REMOTE_HOST="ans_mariusz@192.168.1.10"
SSH_KEY_PATH="/home/mariusz/.ssh/id_rsa"

COMMAND="/usr/bin/ansible-playbook"
INVENTORY="/mnt/ansible/inventory.ini"
PLAYBOOK="/mnt/ansible/main.yml"

DURATION=380  # Total duration to try in seconds
INTERVAL=5    # Interval between retries in seconds

# Function to execute the command via SSH
execute_remote_command() {
    ssh -o StrictHostKeyChecking=no -i "$SSH_KEY_PATH" "$REMOTE_HOST" ""$COMMAND" -i "$INVENTORY" "$PLAYBOOK""
}

# Start time
START_TIME=$(date +%s)

# Loop until the total duration is reached
while true; do
    # Get the current time
    CURRENT_TIME=$(date +%s)
    
    # Calculate the elapsed time
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    
    # Check if the elapsed time is greater than or equal to the total duration
    if [ "$ELAPSED_TIME" -ge "$DURATION" ]; then
        echo "Reached the total duration of $DURATION seconds. Exiting."
        break
    fi
    
    # Execute the remote command
    if execute_remote_command; then
        echo "Command executed successfully."
        break
    else
        echo "Command failed. Retrying in $INTERVAL seconds..."
    fi
    
    # Wait for the interval before retrying
    sleep "$INTERVAL"
done


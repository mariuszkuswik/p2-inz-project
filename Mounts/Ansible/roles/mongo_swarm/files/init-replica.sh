#!/bin/bash

# Log to file
exec > >(tee /scripts/init-replica.log) 2>&1

echo "Starting initialization script"

# Wait for MongoDB to start
sleep 10

# Define the replica set configuration
RS_CONFIG='{
  "_id": "replicaTest",
  "members": [
    { "_id": 0, "host": "control-plane:27017" },
    { "_id": 1, "host": "node1:2018" },
    { "_id": 2, "host": "node2:2019" }
  ]
}'

# Function to initialize the replica set
initialize_replica_set() {
  echo "Initializing replica set"
  mongo --host ${PRIMARY_NODE}:${PRIMARY_PORT} --eval "rs.initiate($RS_CONFIG)"
}

# Function to add this node to the replica set
add_to_replica_set() {
  echo "Adding node to replica set"
  mongo --host ${PRIMARY_NODE}:${PRIMARY_PORT} --eval "rs.add('$CURRENT_NODE:$CURRENT_PORT')"
}

# Function to find the primary node
find_primary_node() {
  for node in control-plane:27017 node1:2018 node2:2019; do
    IS_PRIMARY=$(mongo --quiet --host $node --eval "db.isMaster().ismaster")
    if [ "$IS_PRIMARY" == "true" ]; then
      PRIMARY_NODE=$(echo $node | cut -d':' -f1)
      PRIMARY_PORT=$(echo $node | cut -d':' -f2)
      break
    fi
  done
  echo "Primary node found: $PRIMARY_NODE:$PRIMARY_PORT"
}

# Find the primary node in the replica set
find_primary_node

# If no primary node is found, assume this is a new replica set and initialize it
if [ -z "$PRIMARY_NODE" ]; then
  echo "No primary node found, initializing new replica set"
  CURRENT_NODE=$(hostname)
  if [ "$CURRENT_NODE" == "control-plane" ]; then
    PRIMARY_NODE="control-plane"
    PRIMARY_PORT="27017"
  fi
  initialize_replica_set
else
  # Join the current node to the replica set
  echo "Joining node to existing replica set"
  CURRENT_NODE=$(hostname)
  if [ "$CURRENT_NODE" == "control-plane" ]; then
    CURRENT_PORT="27017"
  elif [ "$CURRENT_NODE" == "node1" ]; then
    CURRENT_PORT="2018"
  elif [ "$CURRENT_NODE" == "node2" ]; then
    CURRENT_PORT="2019"
  fi
  
  # Check if the current node is already part of the replica set
  MEMBER_STATUS=$(mongo --host ${PRIMARY_NODE}:${PRIMARY_PORT} --quiet --eval "rs.status().members")
  MEMBER_EXISTS=$(echo "$MEMBER_STATUS" | grep -o "\"host\": \"$CURRENT_NODE:$CURRENT_PORT\"")
  if [ -z "$MEMBER_EXISTS" ]; then
    add_to_replica_set
  else
    echo "Node is already part of the replica set"
  fi
fi

echo "Initialization script completed"


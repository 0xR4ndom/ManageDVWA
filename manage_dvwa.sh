#!/bin/bash

# Number of instances
NUM_INSTANCES=10

# Base directory where the instance configurations will be stored
BASE_DIR="$HOME/dvwa_instances"

# Function to start instances
start_instances() {
    echo "🚀 Starting $NUM_INSTANCES DVWA instances..."

    mkdir -p "$BASE_DIR"

    for i in $(seq 1 $NUM_INSTANCES); do
        INSTANCE_DIR="$BASE_DIR/dvwa_$i"
        mkdir -p "$INSTANCE_DIR"

        # Generate a specific docker-compose.yml file for each instance
        cat > "$INSTANCE_DIR/docker-compose.yml" <<EOF
volumes:
  dvwa_$i:

networks:
  dvwa_$i:

services:
  dvwa:
    build: .
    image: ghcr.io/digininja/dvwa:latest
    pull_policy: always
    environment:
      - DB_SERVER=db
    depends_on:
      - db
    networks:
      - dvwa_$i
    ports:
      - 0.0.0.0:$((4280 + i - 1)):80
    restart: unless-stopped

  db:
    image: docker.io/library/mariadb:10
    environment:
      - MYSQL_ROOT_PASSWORD=dvwa
      - MYSQL_DATABASE=dvwa
      - MYSQL_USER=dvwa
      - MYSQL_PASSWORD=p@ssw0rd
    volumes:
      - dvwa_$i:/var/lib/mysql
    networks:
      - dvwa_$i
    restart: unless-stopped
EOF

        # Start the docker-compose instance
        (cd "$INSTANCE_DIR" && docker-compose up -d)
    done

    echo "✅ $NUM_INSTANCES DVWA instances are now running!"
}

# Function to stop and remove instances
cleanup_instances() {
    echo "🛑 Stopping and removing $NUM_INSTANCES DVWA instances..."

    for i in $(seq 1 $NUM_INSTANCES); do
        INSTANCE_DIR="$BASE_DIR/dvwa_$i"
        
        if [ -d "$INSTANCE_DIR" ]; then
            echo "🛑 Stopping and removing dvwa_$i..."

            # Navigate to the instance directory and stop docker-compose
            (cd "$INSTANCE_DIR" && docker-compose down -v)

            # Remove the instance directory
            rm -rf "$INSTANCE_DIR"
        else
            echo "⚠️ Instance dvwa_$i does not exist."
        fi
    done

    echo "🚀 Cleaning up Docker resources..."

    # Remove all networks created for DVWA
    for i in $(seq 1 $NUM_INSTANCES); do
        docker network rm dvwa_$i 2>/dev/null
    done

    # Remove all volumes created for DVWA
    for i in $(seq 1 $NUM_INSTANCES); do
        docker volume rm dvwa_$i 2>/dev/null
    done

    echo "✅ All DVWA instances have been successfully removed!"
}

# Check the provided parameter
if [ "$1" == "start" ]; then
    start_instances
elif [ "$1" == "cleanup" ]; then
    cleanup_instances
else
    echo "❌ Usage: $0 {start|cleanup}"
    exit 1
fi

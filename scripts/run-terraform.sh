#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <terraform-command> [terraform-args...] -e <environment>"
    exit 1
}

# Parse command-line arguments
ENVIRONMENT=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -e)
            shift
            ENVIRONMENT=$1
            ;;
        *)
            # The first argument is the Terraform command
            if [ -z "$TERRAFORM_COMMAND" ]; then
                TERRAFORM_COMMAND=$1
            else
                TERRAFORM_ARGS+=("$1")
            fi
            ;;
    esac
    shift
done

# Check if environment is provided
if [ -z "${ENVIRONMENT}" ]; then
    echo "Environment is required."
    usage
fi

# Check if a Terraform command is provided
if [ -z "${TERRAFORM_COMMAND}" ]; then
    echo "Terraform command is required."
    usage
fi

# Navigate to the appropriate directory
cd "./terraform/$ENVIRONMENT" || { echo "Environment directory ./terraform/$ENVIRONMENT does not exist."; exit 1; }

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo

# Execute the Terraform command with the provided arguments
terraform "$TERRAFORM_COMMAND" "${TERRAFORM_ARGS[@]}"

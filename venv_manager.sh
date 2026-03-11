#!/bin/zsh

# Virtual Environment Management Functions
# Source this file in your shell configuration to use these functions

# Function to easily activate virtual environments
# Usage: activate [env_name]
# If no env_name provided, looks for common venv names in current directory
activate() {
    local env_name=""
    
    if [ $# -eq 0 ]; then
        # No argument provided, try to find common venv names
        if [ -d "venv" ]; then
            env_name="venv"
        elif [ -d ".venv" ]; then
            env_name=".venv"
        elif [ -d "env" ]; then
            env_name="env"
        elif [ -d "trader" ]; then
            env_name="trader"
        else
            echo "No virtual environment found. Available options in current directory:"
            find . -maxdepth 1 -name "*env*" -type d 2>/dev/null | sed 's|^./||' | sort
            return 1
        fi
    else
        env_name="$1"
    fi
    
    if [ ! -d "$env_name" ]; then
        echo "Virtual environment '$env_name' not found in current directory."
        return 1
    fi
    
    if [ ! -f "$env_name/bin/activate" ]; then
        echo "Virtual environment '$env_name' doesn't have an activate script."
        return 1
    fi
    
    echo "Activating virtual environment: $env_name"
    source "$env_name/bin/activate"
}

# Function to create a new virtual environment
mkvenv() {
    local env_name="${1:-venv}"
    local python_version="${2:-python3}"
    
    if [ -d "$env_name" ]; then
        echo "Virtual environment '$env_name' already exists."
        return 1
    fi
    
    echo "Creating virtual environment '$env_name' with $python_version..."
    $python_version -m venv "$env_name"
    
    if [ $? -eq 0 ]; then
        echo "Virtual environment '$env_name' created successfully."
        echo "To activate it, run: activate $env_name"
    else
        echo "Failed to create virtual environment."
        return 1
    fi
}

# Function to deactivate and remove virtual environment
rmvenv() {
    local env_name="${1:-venv}"
    
    if [ ! -d "$env_name" ]; then
        echo "Virtual environment '$env_name' not found."
        return 1
    fi
    
    # Check if this venv is currently active
    if [ -n "$VIRTUAL_ENV" ] && [[ "$VIRTUAL_ENV" == *"/$env_name" ]]; then
        echo "Deactivating current virtual environment..."
        deactivate
    fi
    
    echo "Removing virtual environment '$env_name'..."
    rm -rf "$env_name"
    echo "Virtual environment '$env_name' removed."
}

# echo "Virtual environment management functions loaded."
# echo "Available commands: activate [env_name], mkvenv [env_name] [python_version], rmvenv [env_name]"
#!/bin/bash

echo "Building Database Project..."

# Navigate to project directory
cd src/DatabaseProject

# Build the project
dotnet build DatabaseProject.sqlproj --configuration Release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
else
    echo "Build failed!"
    exit 1
fi

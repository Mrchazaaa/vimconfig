#!/bin/bash

# Test script for Neovim configuration
set -e

echo "Testing Neovim configuration..."

# Test basic startup
echo "1. Testing basic startup..."
timeout 10 nvim --headless -c "lua print('Basic startup: OK')" -c "qall!"

# Test configuration loading
echo "2. Testing configuration loading..."
timeout 15 nvim --headless -c "lua print('Config loaded: OK')" -c "qall!"

# Test Lua syntax
echo "3. Checking Lua syntax..."
find . -name "*.lua" -print0 | while IFS= read -r -d '' file; do
    echo "Checking: $file"
    lua -e "assert(loadfile('$file'))" 2>/dev/null || {
        echo "Syntax error in: $file"
        exit 1
    }
done

# Test plugin manager (if using lazy.nvim)
echo "4. Testing plugin manager..."
if [ -f "vimconfig/nvim/lua/lazy-bootstrap.lua" ]; then
    timeout 30 nvim --headless -c "lua require('lazy-bootstrap')" -c "qall!" || {
        echo "Plugin manager test failed"
        exit 1
    }
fi

echo "All tests passed! ✓"
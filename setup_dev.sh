#!/bin/bash

# Mood Surge Development Setup Script
# This script sets up the development environment for the Mood Surge Flutter Flame game

set -e  # Exit on error

echo "🦄 Setting up Mood Surge development environment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [[ ! -f "pubspec.yaml" ]] || [[ ! -d "lib" ]]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Check if FVM is installed
print_status "Checking for FVM (Flutter Version Management)..."
if ! command -v fvm &> /dev/null; then
    print_warning "FVM not found. Installing FVM..."
    dart pub global activate fvm
    print_success "FVM installed successfully"
else
    print_success "FVM is already installed"
fi

# Install Flutter version specified in .fvmrc
print_status "Installing Flutter version from .fvmrc..."
if [[ -f ".fvmrc" ]]; then
    fvm install
    print_success "Flutter version installed successfully"
else
    print_warning ".fvmrc not found, using global Flutter"
fi

# Get dependencies
print_status "Getting Flutter dependencies..."
if command -v fvm &> /dev/null; then
    fvm flutter pub get
else
    flutter pub get
fi
print_success "Dependencies installed successfully"

# Generate code
print_status "Generating code (assets, l10n, etc.)..."
if command -v fvm &> /dev/null; then
    fvm flutter packages pub run build_runner build --delete-conflicting-outputs
else
    flutter packages pub run build_runner build --delete-conflicting-outputs
fi
print_success "Code generation completed"

# Run analyzer
print_status "Running code analysis..."
if command -v fvm &> /dev/null; then
    fvm flutter analyze
else
    flutter analyze
fi

# Run tests
print_status "Running tests to verify setup..."
if command -v fvm &> /dev/null; then
    fvm flutter test
else
    flutter test
fi

# Check if VS Code is installed
if command -v code &> /dev/null; then
    print_status "VS Code detected. Installing recommended extensions..."
    
    # Install recommended extensions
    extensions=(
        "dart-code.dart-code"
        "dart-code.flutter"
        "felixangelov.bloc"
        "usernamehw.errorlens"
        "eamodio.gitlens"
        "nash.awesome-flutter-snippets"
    )
    
    for ext in "${extensions[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            print_success "$ext is already installed"
        else
            print_status "Installing $ext..."
            code --install-extension "$ext"
        fi
    done
else
    print_warning "VS Code not found. Please install VS Code and the recommended extensions manually."
fi

# Setup git hooks (if .git exists)
if [[ -d ".git" ]]; then
    print_status "Setting up git hooks..."
    
    # Create pre-commit hook
    mkdir -p .git/hooks
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit checks..."

# Run analyzer
if command -v fvm &> /dev/null; then
    fvm flutter analyze
else
    flutter analyze
fi

# Run formatter
if command -v fvm &> /dev/null; then
    fvm flutter format --dry-run --set-exit-if-changed .
else
    flutter format --dry-run --set-exit-if-changed .
fi

# Run tests
if command -v fvm &> /dev/null; then
    fvm flutter test
else
    flutter test
fi

echo "Pre-commit checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
    print_success "Git pre-commit hook installed"
fi

# Create useful aliases
print_status "Creating development aliases..."
cat > dev_aliases.sh << 'EOF'
#!/bin/bash
# Mood Surge Development Aliases
# Source this file to add helpful aliases: source dev_aliases.sh

# Flutter commands with FVM
alias fd='fvm flutter run --flavor development -t lib/main_development.dart'
alias fs='fvm flutter run --flavor staging -t lib/main_staging.dart'
alias fp='fvm flutter run --flavor production -t lib/main_production.dart'
alias ft='fvm flutter test'
alias fa='fvm flutter analyze'
alias ff='fvm flutter format .'
alias fg='fvm flutter packages pub run build_runner build --delete-conflicting-outputs'
alias fc='fvm flutter clean && fvm flutter pub get'

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gps='git push'
alias gpl='git pull'

echo "Mood Surge development aliases loaded! 🦄"
echo "Available commands:"
echo "  fd  - Run development"
echo "  fs  - Run staging"
echo "  fp  - Run production"
echo "  ft  - Run tests"
echo "  fa  - Run analyzer"
echo "  ff  - Format code"
echo "  fg  - Generate code"
echo "  fc  - Clean and get dependencies"
EOF

print_success "Development aliases created in dev_aliases.sh"
print_status "To use aliases: source dev_aliases.sh"

# Final setup validation
print_status "Validating setup..."

# Check if we can run the app
print_status "Testing if the app can be built..."
if command -v fvm &> /dev/null; then
    if fvm flutter build apk --debug --flavor development -t lib/main_development.dart > /dev/null 2>&1; then
        print_success "App builds successfully"
    else
        print_warning "App build test failed, but setup is complete"
    fi
else
    if flutter build apk --debug > /dev/null 2>&1; then
        print_success "App builds successfully"
    else
        print_warning "App build test failed, but setup is complete"
    fi
fi

echo ""
print_success "🎮 Mood Surge development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Open the project in VS Code: code ."
echo "2. Install recommended extensions when prompted"
echo "3. Source aliases: source dev_aliases.sh"
echo "4. Start development: fd (or fvm flutter run --flavor development -t lib/main_development.dart)"
echo ""
echo "Useful commands:"
echo "  • fd - Run development"
echo "  • ft - Run tests" 
echo "  • fa - Run analyzer"
echo "  • fg - Generate code"
echo ""
echo "Happy coding! 🦄✨"

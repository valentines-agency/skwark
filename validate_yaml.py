#!/usr/bin/env python3
"""
YAML Configuration Validator
Validates all YAML files in the project for syntax errors
"""

import yaml
import sys
from pathlib import Path

# Color codes
RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
BLUE = '\033[0;34m'
NC = '\033[0m'  # No Color

def validate_yaml_file(file_path):
    """Validate a single YAML file"""
    try:
        with open(file_path, 'r') as f:
            yaml.safe_load(f)
        return True, None
    except yaml.YAMLError as e:
        return False, str(e)
    except Exception as e:
        return False, f"Error reading file: {str(e)}"

def main():
    print("🔍 YAML Configuration Validator")
    print("=" * 50)
    print()

    # List of YAML files to validate
    yaml_files = [
        'melos.yaml',
        'pubspec.yaml',
        'apps/skwark/pubspec.yaml',
        'apps/skwark/analysis_options.yaml',
        '.github/workflows/build.yml',
        '.github/workflows/quick-check.yml',
    ]

    errors = 0
    warnings = 0
    validated = 0

    for yaml_file in yaml_files:
        file_path = Path(yaml_file)

        if not file_path.exists():
            print(f"{YELLOW}⚠{NC} Missing: {yaml_file}")
            warnings += 1
            continue

        valid, error = validate_yaml_file(file_path)

        if valid:
            print(f"{GREEN}✓{NC} Valid: {yaml_file}")
            validated += 1
        else:
            print(f"{RED}✗{NC} Invalid: {yaml_file}")
            print(f"  Error: {error}")
            errors += 1

    print()
    print("=" * 50)
    print()

    if errors == 0 and warnings == 0:
        print(f"{GREEN}✅ All YAML files are valid!{NC}")
        print(f"Validated {validated} files successfully.")
        return 0
    elif errors == 0:
        print(f"{YELLOW}⚠  Warnings: {warnings}{NC}")
        print(f"{GREEN}✓ Validated: {validated}{NC}")
        print()
        print("All existing YAML files are valid.")
        return 0
    else:
        print(f"{RED}✗ Errors: {errors}{NC}")
        print(f"{YELLOW}⚠ Warnings: {warnings}{NC}")
        print(f"{GREEN}✓ Valid: {validated}{NC}")
        print()
        print("Some YAML files have syntax errors. Please fix them.")
        return 1

if __name__ == '__main__':
    sys.exit(main())

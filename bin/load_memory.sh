#!/bin/bash

# Settings
DEFAULT_TARGET=$HOME/ece411/mp2/simulation/modelsim/memory.lst
ASSEMBLER=$HOME/ece411/bin/LC3bAssembler
ADDRESSABILITY=16

# Command line parameters
ASM_FILE=$1
TARGET_FILE=${2:-$DEFAULT_TARGET}
ADDRESSABILITY=${3:-$ADDRESSABILITY}

# Print usage
if [[ "$#" -lt 1 ]]; then
    echo "Compile an LC-3b assembly file and write a memory file for simulation."
    echo "Usage: $0 <asm-file> [memory-file]"
    exit 0
fi

# Remove temporary directory on exit
cleanup()
{
    rm -rf -- "$WORK_DIR"
    # echo "$WORK_DIR"
}
trap cleanup exit

# Create temporary directory
WORK_DIR="$(mktemp -d)"

# Copy files to temporary directory
cp "$ASM_FILE" "$WORK_DIR"

# Fail if assembler cannot be found
if [ ! -x "$ASSEMBLER" ]; then
    echo "Cannot execute assembler at $ASSEMBLER." >&2
    echo "Make sure it exists and is executable." >&2
    exit 1
fi

# Assemble code
"$ASSEMBLER" -b "${WORK_DIR}/$(basename $ASM_FILE)"

OBJ_FILE="${WORK_DIR}/$(basename $ASM_FILE .asm).obj"

# Fail if object file doesn't exist or has no memory content
if [[ ! -e "$OBJ_FILE" || "$(cat "$OBJ_FILE" | wc -c)" -le "16" ]]; then
    echo "Error assembling $ASM_FILE, not generating memory file" >&2
    exit 2
fi

# Fail if the target directory doesn't exist
if [[ ! -d "$(dirname "$TARGET_FILE")" ]]; then
    echo "Directory $(dirname "$TARGET_FILE") does not exist." >&2
    echo "Did you specify the correct target path? Aborting." >&2
    exit 3
fi

# Ask if user wants to overwrite target
if [ -e "$TARGET_FILE" ]; then
    echo "Target file $TARGET_FILE exists."
    read -p "Overwrite? [y/N] " CONF
    shopt -s nocasematch
    if [[ "${CONF}" != "y" && "${CONF}" != "yes" ]]; then
        echo "Aborting." >&2
        exit 0
    fi
    shopt -u nocasematch
fi

# Write memory to file
{
    echo -n "@"
    printf "%016X\n" $(($(hexdump -ve '1/8 "%u\n"' -n 8 "$OBJ_FILE") / $ADDRESSABILITY))
    hexdump -ve $ADDRESSABILITY'/1 "%02X " "\n"' -s 16 "$OBJ_FILE" \
        | awk '{for (i = NF; i > 0; i--) printf "%s", $i; print ""}'
} > "$TARGET_FILE"

echo "Assembled $ASM_FILE and wrote memory contents to $TARGET_FILE"

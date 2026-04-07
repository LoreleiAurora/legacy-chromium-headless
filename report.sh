#!/bin/bash

set +e

OUTPUT_FILE="build_results_$(date +%Y%m%d_%H%M%S).txt"
TMP_DIR=$(mktemp -d)
echo "Results will be written to: $OUTPUT_FILE" >&2

UNAVAILABLE_FILE="$TMP_DIR/unavailable.txt"
SUCCESS_FILE="$TMP_DIR/success.txt"
DOCKER_FILE="$TMP_DIR/docker.txt"
TEST_FILE="$TMP_DIR/test.txt"
DRIVER_FILE="$TMP_DIR/driver.txt"

touch "$UNAVAILABLE_FILE" "$SUCCESS_FILE" "$DOCKER_FILE" "$TEST_FILE" "$DRIVER_FILE"

for v in {48..160}; do
    echo "Processing version $v..." >&2
    OUTPUT=$(python3 build.py "$v" 2>&1)
    RC=$?

    if echo "$OUTPUT" | grep -q "version unavailable: $v"; then
        echo "$v" >> "$UNAVAILABLE_FILE"
    elif [ $RC -eq 0 ]; then
        echo "$v" >> "$SUCCESS_FILE"
    else
        # Check for ChromeDriver failed to start
        if echo "$OUTPUT" | grep -q "ChromeDriver failed to start"; then
            ERR_MSG=$(echo "$OUTPUT" | grep -A2 "ChromeDriver failed to start" | head -3)
            echo "$v | $ERR_MSG" >> "$DRIVER_FILE"
        # Check for test errors
        elif echo "$OUTPUT" | grep -q "Test failed:"; then
            ERR_MSG=$(echo "$OUTPUT" | grep "Test failed:" | head -1)
            echo "$v | $ERR_MSG" >> "$TEST_FILE"
        # Docker errors (build failed)
        elif echo "$OUTPUT" | grep -q "Built:"; then
            ERR_MSG=$(echo "$OUTPUT" | grep -i "error" | head -1)
            [ -z "$ERR_MSG" ] && ERR_MSG=$(echo "$OUTPUT" | tail -3 | sed ':a;N;$!ba;s/\n/ | /g')
            echo "$v | $ERR_MSG" >> "$DOCKER_FILE"
        else
            ERR_MSG=$(echo "$OUTPUT" | grep -i "error\|failed" | head -1)
            [ -z "$ERR_MSG" ] && ERR_MSG="Exit code $RC"
            echo "$v | $ERR_MSG" >> "$TEST_FILE"
        fi
    fi
done

{
    echo "=========================================="
    echo "Chrome Build Test Results"
    echo "Generated: $(date)"
    echo "=========================================="
    echo ""

    # Count and list unavailable
    UNAVAILABLE=($(cat "$UNAVAILABLE_FILE" 2>/dev/null))
    echo "=== Unavailable (${#UNAVAILABLE[@]}) ==="
    echo "${UNAVAILABLE[*]}"
    echo ""

    # Count and list success
    SUCCESS=($(cat "$SUCCESS_FILE" 2>/dev/null))
    echo "=== Success (${#SUCCESS[@]}) ==="
    echo "${SUCCESS[*]}"
    echo ""

    # Docker errors - group by error message
    echo "=== Docker Errors ==="
    if [ -s "$DOCKER_FILE" ]; then
        awk -F' \\| ' '
        {
            version=$1
            msg=""
            for(i=2;i<=NF;i++) { if(msg=="") msg=$i; else msg=msg" | "$i }
            msgs[msg] = msgs[msg] " " version
        }
        END {
            for (msg in msgs) {
                print ""
                print "Error:", msg
                print "Versions:", msgs[msg]
            }
        }' "$DOCKER_FILE"
    else
        echo "None"
    fi
    echo ""

    # Test errors - group by error message
    echo "=== Test Errors ==="
    if [ -s "$TEST_FILE" ]; then
        awk -F' \\| ' '
        {
            version=$1
            msg=""
            for(i=2;i<=NF;i++) { if(msg=="") msg=$i; else msg=msg" | "$i }
            msgs[msg] = msgs[msg] " " version
        }
        END {
            for (msg in msgs) {
                print ""
                print "Error:", msg
                print "Versions:", msgs[msg]
            }
        }' "$TEST_FILE"
    else
        echo "None"
    fi
    echo ""

    # Driver errors - group by error message
    echo "=== ChromeDriver Failed to Start ==="
    if [ -s "$DRIVER_FILE" ]; then
        awk -F' \\| ' '
        {
            version=$1
            msg=""
            for(i=2;i<=NF;i++) { if(msg=="") msg=$i; else msg=msg" | "$i }
            msgs[msg] = msgs[msg] " " version
        }
        END {
            for (msg in msgs) {
                print ""
                print "Error:", msg
                print "Versions:", msgs[msg]
            }
        }' "$DRIVER_FILE"
    else
        echo "None"
    fi
    echo ""
    echo "=========================================="
} > "$OUTPUT_FILE"

rm -rf "$TMP_DIR"

echo "Done. Results: $OUTPUT_FILE" >&2

#!/usr/bin/env bash

# Print ldd and so glibc version
echo "Running ldd to see ldd and so glibc version"
ldd --version

# Run integration tests
PROFILE=0
ARGS=()


for arg in "$@"; do
    if [ "$arg" = "--profile" ]; then
        PROFILE=1
    else
        ARGS+=("$arg")
    fi
done

# Run integration tests with profile flag 
if [ "$PROFILE" -eq 1 ]; then
    (cd tests && python3 -m cProfile -o profile.stats tests.py "${ARGS[@]}")
    # Generate a readable report
    (cd tests && python3 -c '
import pstats
from pstats import SortKey
p = pstats.Stats("profile.stats")
p.sort_stats(SortKey.TIME).print_stats(30)
    ')
else
    # Run tests normally.
    (cd tests && python3 tests.py "${ARGS[@]}")
fi

exit_code=$?
exit $exit_code

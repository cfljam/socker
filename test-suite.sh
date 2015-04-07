#!/bin/bash
# ==========================================================
# USAGE:
# ./test-suite.sh
#
# ADDING TESTS
# - add the command to run suffixing with || fail "message"
#   or add a test and call fail if the output is not as
#   expected
# - i.e. which vcf-merge || fail "vcf-merge not installed"
#
# ==========================================================

# Usage: fail "your message"
function fail
{
    echo "[ERROR] $@" >&2
    exit 127
}

## report all commands from now
set -xe

## basic test of python installation
python2 -c "import Bio,BCBio.GFF" || fail "basic python import"


## basic check vcftools was installed
which vcf-merge || fail "no vcf-merge"

## basic check samtools was installed
which samtools || fail "no samtools"

## this is success
exit 0

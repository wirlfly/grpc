#!/bin/bash
# Copyright 2015-2016, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -ex

CONFIG=${CONFIG:-opt}
NUNIT_CONSOLE="mono packages/NUnit.Runners.2.6.4/tools/nunit-console.exe"

# change to gRPC repo root
cd $(dirname $0)/../..

(cd src/csharp; $NUNIT_CONSOLE $@)

if [ "$CONFIG" = "gcov" ]
then
  # Generate the csharp extension coverage report
  gcov objs/gcov/src/csharp/ext/*.o
  lcov --base-directory . --directory . -c -o coverage.info
  lcov -e coverage.info '**/src/csharp/ext/*' -o coverage.info
  genhtml -o reports/csharp_ext_coverage --num-spaces 2 \
    -t 'gRPC C# native extension test coverage' coverage.info \
    --rc genhtml_hi_limit=95 --rc genhtml_med_limit=80 --no-prefix
fi



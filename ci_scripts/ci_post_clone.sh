#!/bin/sh

# install swiftlint
brew install swiftlint

# 실행 경로로 이동
cd ..

# tuist fetch
.tuist-bin/tuist fetch

# tuist generate
.tuist-bin/tuist generate

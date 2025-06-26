#!/usr/bin/env bash

set -o errexit


# Install npm packages
npm install

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate

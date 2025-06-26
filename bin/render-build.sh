#!/usr/bin/env bash

set -o errexit

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install npm packages
npm install

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate

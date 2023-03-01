#!/bin/bash
#
# Copyright (C) The Arvados Authors. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0

# Start the first process
(cd /var/www/arvados-api/current && RAILS_ENV=production passenger start) &

# Start the second process
arvados-controller &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?

#!/bin/bash

# Front facing menu for peer.bash and server.bash

# Implement the following
# 1) Add another switch with an argument that checks to see if the user exists in the wg0.conf file
# 2) Edit the manage-users.bash script and add the code to delete a user from the wg0.conf file using sed
# 3) Create a menu for security admin tasks that performs the tasks:
#   3a) List open network sockets
#   3b) Check if any user besides root has a UID of 0
#   3c) Check the last 10 logged in users
#   3d) See currently logged in users
# 4) Create a new user and add the menu as their shell

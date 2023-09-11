#!/bin/bash

# ip addr gets entire ip address
# global only appears in the line with the relevent information
# printing the second word on that line gives the required information
ip addr | awk '/global/ {print $2}'
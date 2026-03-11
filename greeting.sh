#!/bin/bash
echo "What is your name?"
read user_name
current_day=$(date +%A)
echo "Hello, $user_name! Today is $current_day."
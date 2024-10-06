#!/bin/bash

service apache2 start
service cron start

./venv.sh flask snitch_start
./venv.sh flask run --host 0.0.0.0 --port 8888

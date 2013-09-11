#!/bin/sh
APP=yokogao
ERL=erl
COOKIE=yokogao
NODE_NAME=$APP@127.0.0.1
CONFIG=priv/app.config
LIBS_DIR="deps"

exec $ERL -pa ebin \
    -boot start_sasl \
    +A 256 \
    -name $NODE_NAME \
    -setcookie $COOKIE \
    -config $CONFIG \
    -env ERL_LIBS $LIBS_DIR \
    -s $APP

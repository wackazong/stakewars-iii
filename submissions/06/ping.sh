#!/bin/bash
# Ping call to renew Proposal added to crontab

NEAR_ENV=shardnet
LOGS=/home/<USER_ID>/logs
POOLID=<YOUR_POOL_ID>
ACCOUNTID=<YOUR_ACCOUNT_ID>

echo "------------------------------------------------------------------------------------------------------------------" >> $LOGS/ping.log
date >> $LOGS/ping.log
GAS_PRICE=$(curl -s -X POST https://rpc.shardnet.near.org -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"dontcare","method":"gas_price","params":[null]}' | jq -r '.result.gas_price')
echo "INFO Gas price is $GAS_PRICE" >> $LOGS/ping.log
if (( $GAS_PRICE > 10000000000 ));then
	echo "WARNING Gas price too high, not doing ping" >> $LOGS/ping.log
else
	near call $POOLID.factory.shardnet.near ping '{}' --accountId $ACCOUNTID.shardnet.near --gas=300000000000000 >> $LOGS/ping.log
fi

echo >> $LOGS/ping.log
RESULT="$(near proposals)"
if grep -q "$POOLID" <<< "$RESULT"; then
        grep "Proposals for" <<< "$RESULT" >> $LOGS/ping.log
        grep " Status " <<< "$RESULT" >> $LOGS/ping.log
        grep "$POOLID" <<< "$RESULT" >> $LOGS/ping.log
fi

echo >> $LOGS/ping.log
RESULT="$(near validators current)"
if grep -q "$POOLID" <<< "$RESULT"; then
        grep "Validators " <<< "$RESULT" >> $LOGS/ping.log
        grep " Validator Id " <<< "$RESULT" >> $LOGS/ping.log
        grep "$POOLID" <<< "$RESULT" >> $LOGS/ping.log
fi

echo >> $LOGS/ping.log
RESULT="$(near validators next)"
if grep -q "$POOLID" <<< "$RESULT"; then
        grep "Next validators " <<< "$RESULT" >> $LOGS/ping.log
        grep " Status " <<< "$RESULT" >> $LOGS/ping.log
        grep "$POOLID" <<< "$RESULT" >> $LOGS/ping.log
fi
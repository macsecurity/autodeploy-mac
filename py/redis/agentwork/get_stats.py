#!/usr/bin/env python

from py.redis.client import Client
from py.redis.keys import AgentWork as K

add_count = Client.get(K.STATS_ADD)
delete_count = Client.get(K.STATS_DELETE)

print(f'Add Operations    : {add_count}')
print(f'Delete Operations : {delete_count}')

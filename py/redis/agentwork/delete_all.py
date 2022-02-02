#!/usr/bin/env python

from py.redis.client import Client
from py.redis.keys import AgentWork as K

print('Searching for keys...')

keys = Client.keys(K.ALL)
count = len(keys)

print(f'Found {count} keys; deleting...')

deleted = 0

for key in keys:
    Client.delete(key)
    deleted += 1
    if deleted % 500 == 0:
        print('deleted {deleted} of {count}')

print(f'Successfully deleted {deleted} of {count}')

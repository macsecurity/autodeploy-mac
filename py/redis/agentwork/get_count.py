#!/usr/bin/env python

from py.redis.client import Client
from py.redis.keys import AgentWork as K

count = len(Client.keys(K.ALL))
print(f'found {count} keys')

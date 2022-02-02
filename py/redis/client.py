from os import getenv
from redis import StrictRedis


def get_client():
    class CredentialsError(Exception):
        def __init__(self):
            super().__init__('R_HOST, R_PORT, and R_AUTH environment variables required')

    if None in {
            host := getenv('R_HOST'),
            port := getenv('R_PORT'),
            auth := getenv('R_AUTH'),
            }:
        raise CredentialsError()

    return StrictRedis(host=host, port=port, password=auth, decode_responses=True)

Client = get_client()

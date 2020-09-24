import random

from managers.generators import UniqueShortKeyGenerator
from utils import base62
from utils.redis import redis_client


class AutoIncShortKeyGenerator(UniqueShortKeyGenerator):
    """
    Auto incrementing short key generator.
    Uses Redis to keep the latest auto incrementing counter.
    With each increment, adds a random value between 1 and `random_step` to the counter.
    """
    KEY = 'shortkey:gen:autoinc'
    MAX_STEP = 1000

    DEFAULT_INIT = 1599647941

    def __init__(self, init_value=DEFAULT_INIT, random_step=0):
        """
        :param init_value int: The value to initiaize the counter with.
        :param random_step int: The maximum integer for the random step to be added to the counter.
        """
        redis = redis_client()
        redis.setnx(self.KEY, init_value)
        self.random_step = min(max(1, random_step), self.MAX_STEP)
        self._init_value = init_value

    def generate(self, url) -> str:
        redis = redis_client()
        step = 1 if self.random_step <= 1 else random.randint(1, self.random_step)
        uid = redis.incr(self.KEY, step)
        return base62.encode(uid)

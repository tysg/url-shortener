import random

from managers.generators import UniqueShortKeyGenerator
from utils import base62
from utils.snowflake import SnowflakeClient


class SnowflakeShortKeyGenerator(UniqueShortKeyGenerator):
    """
    Snowflake-based short key generator.
    Format: timestamp | worker ID | sequence number
    """
    STEP_SHIFT_BITS = 3
    STEP_MAX = (1 << STEP_SHIFT_BITS) - 1

    def __init__(self, snowflake_client: SnowflakeClient):
        """
        :param snowflake_client utils.snowflake.SnowflakeClient: The snowflake client to generate snowflake IDs.
        """
        self._snowflake_client = snowflake_client

    def generate(self, url) -> str:
        step = random.randint(0, self.STEP_MAX)
        uid = self._snowflake_client.next_id()
        return base62.encode((uid << self.STEP_SHIFT_BITS) | step)

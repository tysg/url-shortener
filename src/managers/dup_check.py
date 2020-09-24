from typing import Optional

import redis_lock

from accessors import UrlsTabAccessor
from common.exceptions import ShortUrlException
from managers.default import DefaultShortUrlManager
from managers.generators import RandomShortKeyGenerator
from utils.rand import random_string
from utils.redis import redis_client


class DupCheckShortUrlManager(DefaultShortUrlManager):

    def __init__(self, urls_tab_accessor: UrlsTabAccessor, short_key_generator: RandomShortKeyGenerator):
        super().__init__(urls_tab_accessor, short_key_generator)

    def _generate_new_short_key(self, url):
        short_key = self._shorten(url)
        if short_key is None:
            raise ShortUrlException('system busy, try it later')
        return short_key

    def _shorten(self, url: str, with_random_key: bool = None, retries: int = 3) -> Optional[str]:
        if retries <= 0:
            return None

        target = f'{url}{random_string()}' if with_random_key else url
        short_key = self.short_key_generator.generate(target)

        match = self.urls_tab_accessor.find_last_by_short_key(short_key)

        if match == url:
            return short_key
        elif match is not None:
            # short key conflict
            return self._shorten(url, with_random_key=True, retries=retries - 1)

        lock = redis_lock.Lock(redis_client(), short_key, expire=10)

        if lock.acquire(blocking=False):
            try:
                # recheck within lock
                match = self.urls_tab_accessor.find_last_by_short_key(short_key)
                if match is None:
                    self.urls_tab_accessor.create(short_key, url)
                    return short_key
                elif match == url:
                    return short_key
                else:
                    # short key conflict with other existing url
                    return self._shorten(url, with_random_key=True, retries=retries - 1)
            finally:
                lock.release()

        return self._shorten(url, retries=retries - 1)

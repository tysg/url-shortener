import hashlib

from managers.generators import RandomShortKeyGenerator
from utils import base62


class Sha1StrShortKeyGenerator(RandomShortKeyGenerator):
    """
    SHA1-based short key generator.
    May generate conflicting SHA1 keys.
    """

    def generate(self, url) -> str:
        random_id = self._sha1(url)
        return base62.encode(random_id)[:6]

    @staticmethod
    def _sha1(url) -> int:
        sha1hex = hashlib.sha1(str.encode(url)).hexdigest()
        return int(sha1hex, 16)

from managers import AbstractShortKeyGenerator


class ShortKeyGenerator(AbstractShortKeyGenerator):

    def generate(self, url) -> str:
        raise NotImplementedError

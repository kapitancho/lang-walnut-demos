module demo-us:

ShortenedUrlList = :[];
ShortenedUrlData = [id: String<36>, originalUrl: String<1..>, shortenedUrl: String<1..>];
ShortenedUrl = $[data: ShortenedUrlData];

ShortenedUrlRepository = :[];
ShortenedUrlRepository->store(^[shortenedUrl: ShortenedUrlData] => Null) :: null;
ShortenedUrlRepository->getByShortUrl(^[shortUrl: String<1..>] => ShortenedUrlData) :: 1;
ShortenedUrlRepository->getById(^[id: String<36>] => ShortenedUrlData) :: 1;
ShortenedUrlRepository->removeById(^[id: String<36>] => Null) :: null;

ShortenedUrlList->shortenUrl(^[url: String<1..>] => ShortenedUrl) :: 1;
ShortenedUrlList->getByShortenedUrl(^[shortUrl: String<1..>] => ShortenedUrl) :: 1;
ShortenedUrlList->getById(^[id: String<36>] => ShortenedUrl) :: 1;

ShortenedUrl->remove(^Null => Null) :: 1;
ShortenedUrl->data(^Null => ShortenedUrlData) :: $data;

UrlShortener = :[];
UrlShortener->run(^Any => Any) :: [
    'Hello!'
];

main = ^Any => String :: UrlShortener()->run->printed;

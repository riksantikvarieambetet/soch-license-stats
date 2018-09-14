# SOCH License Stats

Calculates SOCH queries of unlicensed images by institution as well as related stats.

The program results in a CSV file with:

 - the name of the institution
 - the short name of the institution
 - the total image count
 - the number of images without any license specified
 - a SOCH query that lists the items with such an image 

## Notes

This program will only detect images without a license specified, therefor invalid licenses such as `null` will not be detected(aka images from the Swedish National Heritage Board).

## Running

This program needs pipenv to be installed on your computer.

1. Clone or download this repository.
2. Run `pipenv run python liz.py` within this directory.
3. Enter your SOCH API key when prompted to do so.
4. After a while a CSV file will be generated in this directory.

---

# `soch-license-stats.pl`

`liz.py` didn't really do everything I wanted, and I don't speak Python, so I rewrote it in Perl. (This has the added side-effect that it's now even easier to read. 😉)

`soch-license-stats.pl` outputs a CSV matrix showing, for each data provider, how many images they publish under each of the different licenses that are in use in SOCH, as well as images with no licensing information, and the total number of images provided. The list of providers and licenses in use are fetched at run time.

## Running

1. `soch-license-stats.pl` requires Perl 5.22 or greater, and uses a few non-core modules. Using [`cpanm`](https://metacpan.org/pod/App::cpanminus), run `cpanm LWP::UserAgent Text::CSV URI::Escape XML::XPath` to install them.
1. Run `soch-license-stats.pl`
1. Enter your SOCH API key when prompted to do so, or press RETURN to use a default test key.
1. …time passes…
1. A CSV appears in the current working directory!

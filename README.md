# SOCH License Stats

Calculates SOCH queries of unlicensed images by institution as well as related stats.

`soch-license-stats.pl` outputs a CSV matrix showing, for each data provider, how many images they publish under each of the different licenses that are in use in SOCH, as well as images with no licensing information, and the total number of images provided. The list of providers and licenses in use are fetched at run time.

## Running

1. `soch-license-stats.pl` requires Perl 5.22 or greater, and uses a few non-core modules. Using [`cpanm`](https://metacpan.org/pod/App::cpanminus), run `cpanm LWP::UserAgent Text::CSV URI::Escape XML::XPath` to install them.
2. Run `soch-license-stats.pl`
3. Enter your SOCH API key when prompted to do so, or press RETURN to use a default test key.
4. ...time passes...
5. A CSV appears in the current working directory!

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

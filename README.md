# Band History Project

This is the data repository for materials related to the [Cornhusker Marching
Band History](https://bandhistory.unl.edu) project. Using
[datura](https://github.com/CDRH/datura), scripts in this repository convert
source documents to HTML and populate an Elasticsearch index.

## Overview of Materials

__AUTHORITY__

In `source/authority` there are several CSVs, many of which are from the
UNL Archives and Special Collections (SPEC), others of which were made to imitate
the SPEC format. They largely describe scans of images and documents, but several
documents are used as authority files for people.

- `2029-lentz` SPEC: describes materials from the Lentz accession
- `donated` are resources given to the project and typically assigned an id `band.img.0000`
- `other-collections-partial` SPEC: miscellaneous collections, including ROTC
- `personography` is a list of people in the materials
- `rg130815-reels` SPEC: information about the band collection's digitized reels
- `rg130815` SPEC: materials from the band collection
- `rg130833` SPEC: materials from Snider band collection
- `rg421201` SPEC: materials from athletics collection

__CSV__

`source/csv` is a bit weird, because it contains files related to those in authority but which
OVERRIDE authority. That is to say, there might be an entry for item X in an authority file,
but if it does not appear in `images.csv` it will not appear on the site, and `images.csv` may
also change the title or date of the item.

This is because by and large the items in authority are not easily mutable -- they live in SPEC
and would require an archivist to change them. Therefore when I would like to record different
information (like fixing a misspelled name, making a less generic title, adding a date), I am
changing the `source/csv` version of item X rather than the one in the SPEC spreadsheet.

Note that footage also is a little funky, because each row is a snippet taken from a larger reel,
so the scripts actually treat each clip as an item, but have to figure out which reel to also
draw information from in order to create the HTML and ES descriptions.

__TEI__

`source/tei` has not bee completed yet, but there are some demos in `source/drafts/tei`. Eventually
this is where documents will live, such as petitions, newspaper articles, correspondence, etc.

__WEBS__

Several pages were easier to create in HTML than to encode in some format and transform. For example,
the interviews and the transcript of a concert exist primarily in the Rails repository. If described in
one of the webs yaml files, those pages will be "scraped" and their contents added to Elasticsearch
to be searched. Using data attributes, these scripts can also grab dates, people, etc, to populate
the index.

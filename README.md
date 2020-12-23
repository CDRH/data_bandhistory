# Band History Data Repository

This repository is intended to be used with [Datura](https://github.com/cdrh/datura).

There are a number of formats and sources represented in this repository.

- authority (records from archives, a personography file, etc)
- csv (images and footage records)
- tei (documents)
- webs (scraped from website's stories sections)

Post all to the API:

```
bundle exec post
```

Create footage HTML:

```
bundle exec post -x html
```

## Authority Files

Typically, these should not be altered in this repository, but should be copied in from their original source.
Contact Archives & Special Collections to get the latest copy of any of the CSV files which are labeled with numbers,
a the number indicates the record group of the collection. These files contain the archives descriptions given to
digitized images / scans from those collections.  `rg570904-reels.csv` contains the Luna information for the digitized
reels of footage.

The personography file is maintained by the PIs in Box and should be downloaded from there is refreshing the contents.

The only file which MAY be altered here, is `donated.csv` which is a collection of images with the id pattern `band.img.0000`.
This repository is the only place that file is currently maintained.

## CSV

`footage.csv` (which refers to `rg570904-reels.csv`) and `images.csv` (which refers to any of the archive authority files)
live here. `images.csv` contains "overriding" fields to correct values in the Archives records.

When transforming `footage.csv` to HTML, it uses the reels fields to build a record of the footage clip and the metadata from
which it came. The associated reel row is also added to the API text field for search purposes.

## TEI

There is not yet any TEI content, which will represent letters, newspaper clippings, and other documents. For example templates,
see `source/drafts/tei`.

## WEBS

Right now, this is set up with a yaml file to read certain URLs from the website's contents. The pages are encoded with data
attributes, such as `data-field="title"` and `data-person` which are used to populate the API. `data-person`, for example,
points to a record in the personography file which is then used to add people.

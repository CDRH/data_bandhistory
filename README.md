# Data Repository for Cornhusker Marching Band History

## About This Data Repository

**How to Use This Repository:** This repository is intended for use with the [CDRH API](https://github.com/CDRH/api) 
and the [Cornhusker Marching Band History Ruby on Rails application](https://github.com/CDRH/bandhistory_rails).

**Data Repo:** [https://github.com/CDRH/data_bandhistory](https://github.com/CDRH/data_bandhistory)

**Script Languages:** HTML, Ruby

**Source Files:** There are a number of formats and sources represented in this repository.

- authority csv (records from archives, a personography file, etc)
- csv (images and footage records)
- tei (documents)
- webs (scraped from website's stories sections)

### Authority Files

Typically, these should not be altered in this repository, but should be copied in from their original source.
Contact Archives & Special Collections to get the latest copy of any of the CSV files which are labeled with numbers.
The number indicates the record group of the collection. These files contain the archives descriptions given to
digitized images / scans from those collections.  `rg570904-reels.csv` contains the Luna information for the digitized
reels of footage.

The personography file is maintained by the PIs and should be re-downloaded from there.

The only file which MAY be altered here, is `donated.csv` which is a collection of images with the id pattern `band.img.0000`.
This repository is the only place that file is currently maintained.

### CSV

`footage.csv` (which refers to `rg570904-reels.csv`) and `images.csv` (which refers to any of the archive authority files)
are in source/csv. `images.csv` contains "overriding" fields to correct values in the Archives records.

When transforming `footage.csv` to HTML, it uses the reels fields to build a record of the footage clip and the metadata from
which it came. The associated reel row is also added to the API text field for search purposes.

### TEI

There is not yet any TEI content, which will represent letters, newspaper clippings, and other documents. For example templates,
see `source/drafts/tei`.

### WEBS

Right now, this is set up with a yaml file to read certain URLs from the website's contents. The pages are encoded with data
attributes, such as `data-field="title"` and `data-person` which are used to populate the API. `data-person`, for example,
points to a record in the personography file which is then used to add people.

## About Cornhusker Marching Band History

This project was developed as a partnership between the Archives & Special Collections, 
University of Nebraska-Lincoln Libraries and the Cornhusker Marching Band with the support of the Center 
for Digital Research in the Humanities. This website was created not as an all encompassing 
or ongoing history of the band, but as a snapshot in time of band materials in the Archives & Special Collections.

**Project Site:** [https://bandhistory.unl.edu/](https://bandhistory.unl.edu/)

**Rails Repo:** [https://github.com/CDRH/bandhistory_rails](https://github.com/CDRH/bandhistory_rails)

**Credits:** [https://bandhistory.unl.edu/about](https://bandhistory.unl.edu/about)

**Work to Be Done:** [https://github.com/CDRH/bandhistory_rails/issues](https://github.com/CDRH/bandhistory_rails/issues)

## Copyright Information

See [Archives page](https://bandhistory.unl.edu/about/archives).

## Technical Information

See project site [Technical information page](https://bandhistory.unl.edu/about/technology).

See the [Datura documentation](https://github.com/CDRH/datura) for general updating and posting instructions. 

### Quick notes

Post all to the API:

```
bundle exec post
```

Create footage HTML:

```
bundle exec post -x html
```

## About the Center for Digital Research in the Humanities

The Center for Digital Research in the Humanities (CDRH) is a joint initiative of the University of Nebraska-Lincoln Libraries and the College of Arts & Sciences. 
The Center for Digital Research in the Humanities is a community of researchers collaborating to build digital content and systems in order to generate and express knowledge of the humanities. We mentor emerging voices and advance digital futures for all.

**Center for Digital Research in the Humanities GitHub:** [https://github.com/CDRH](https://github.com/CDRH)

**Center for Digital Research in the Humanities Website:** [https://cdrh.unl.edu/](https://cdrh.unl.edu/)

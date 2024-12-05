# LREditionDetails

---
This plug-in provides metadata for print editions.

## Features

---

* Set source tag by the photo ID
* Provide tags for print editions
* Create QR Codes

## Prerequisites

* Java 21 or newer must be installed.
* java.exe must be in your PATH

---

## Installation

---

1. Download the zip archive LREditionDetails-1.1.0.0.zip from
   [GitHub](https://github.com/sto3014/LREditionDetails/archive/refs/tags/1.1.0.0.zip).
2. Extract the archive in the download folder.
3. Install plug-in
   1. On Windows  
      In Explore goto `Downloads\LREditionDetails-1.1.0.0` and double click `install.bat`.
   2. On macOS  
      Open a terminal window, change to `Downloads/LREditionDetails-1.1.0.0` and execute `install.sh`:
       ```
       -> ~ cd Downloads/LREditionDetails-1.1.0.0
       -> ./install.sh 
       ```
4. Restart Lightroom

## Usage

---

### Source tag

The Lightroom source tag can be set by the internal photo ID and the catalog name. The photo ID is unique for each
catalog. The catalog name is the filename of the Lightroom catalog without the suffix. Also the version of the catalog
will be removed from ith name. Example:

* Catalog filename: mycatalog-v13.lrcat
* Photo ID: 12345678
* value of source tag will be: mycatalog-12345678

To set source you must select one or more photos or videos and select _Set source by photo ID_ from the
_Library/Plug-In Extras_ menu.

Remarks: The source tag can be used in file naming templates of the export dialog. 

### Tags for editions

In the new tagset _Edition Details_ underneath of label _Edition Details_ you will find 6 new tags:

* Catalog type
* Catalog name
* Lot number
* Run size
* Signature
* QR code
* Comment

The drop down list _Catalog type_ has two values: _External_ and _Lightroom_. The value _External_ can be used if
_Catalog name_ and _Lot number_ comes out of an external catalog index. If you want to display Lightroom information for
the catalog name and the lot number set _Catalog type_ to _Lightroom_ and initialize their values by selecting
_Initialize edition details_ from the _Library/Plug-In Extras_ menu.
This action sets _Catalog name_ to the filename of the Lightroom catalog (without file and version suffix) and _Lot
number_ to the internal photo ID.

When you print your photos, you can note the print run size in the corresponding tag and use the signature dropdown
values for the purpose of your prints.

The _Signature_ drop down tag has 5 values:

* _E.H._ = Epreuve d’Artiste  
  The designation E. A. instead of the numbering of the print run means that these are prints by the artist for his own
  use, which were printed in addition to the print run.
* _H.C._ = Hors Commerce  
  Are prints outside the trade that are not always numbered, e.g. for friends of the artist.
* _A.P._ = Artist Print  
  Similar to E.A. / H.C. - proof prints for the artist, sometimes also as prints outside the trade for friends or
  colleagues.
* _P.P._ = Printers Proof  
  Specimen copies from the printer if the artist does not print himself but commissions the work.
* _E.E._ = Epreuve d’Eta  
  The sheets marked in this way are proofs or state prints that were printed during the artist's work for checking
  purposes. The sheets do not yet have the final version printed as an edition and are therefore often coveted
  collector's items.

### QR code

QR code images (png) can be created by selecting one or more photos or videos and select _Create QR code_ from the
_Library/Plug-In Extras_ menu.
The created code uses the content of the new _QR code_ tag. Other configuration parameters can be set in the _QR code_
dialog. 
The image is create in your picture folder, subfolder QRCodes.

## Reference

The descriptions of the signature values are taken
from [Signaturen](https://wp.radiertechniken.de/anhang/auflage-und-nummerierung/auflage/)
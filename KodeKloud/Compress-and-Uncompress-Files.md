# Compress and Uncompress Files (Optional)

Most Linux sytems have at least 3 compression utilities pre-installed:

- gizip
- bzip2
- xz

They compress the file and automatically delete the file afterwards if you don't tell it to keep it (-k | --keep):

#### gzip file1

#### gzip --keep file1

#### gizip --list file1

    file1.gz

    compressed | uncompressed | ratio | name
    71          78              39.7%   file1

#### bzip2 file2
    file2.bz2

#### xz file3
    file3.xz

To uncompress the files:

#### gunzip file1.gz       

    gzip --decompress file1.gz

#### bunzip file2.bz2
    
    bzip2 --decompress file2.bz2

#### unxz file3.xz

    xz --decompress file3.xz


## ** to compress files and directories use zip:

#### zip archive file1
#### zip archive.zip file1

#### zip -r archive.zip Pictures/

#### unzip archive.zip


## Compression and Decompression with tar:

#### tar --create --file archive.tar file1

#### gzip archive.tar
    archive.tar.gz

#### gzip --keep archive.tar
    archive.tar     archive.tar.gz

#### tar --create --gzip --file archive.tar.gz file1
####    tar czf archive.tar.gz file1

#### tar --create --bzip2 --file archive.tar.bz2 file1
####    tar cjf archive.tar.bz2 file1

#### tar create --xz --file archive.tar.xz file1 
####    tar cJf archive.tar.xz file1

#### tar --create --autocompress --file archive.tar.gz file1

#### tar caf archive.xz file1

#### tar --extract --file archive.tar.gz

#### tar xf archive.tar.gz file1




ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Compress-and-Uncompress-Files$ ls
Compression-and-Decompression-Utilities-1.png
Compression-and-Decompression-Utilities-2.png
Compression-and-Decompression-Utilities-3.png
Compression-and-Decompression-with-tar.png


 

Archive, Back Up, Compress, Unpack, and Uncompress Files (Optional)

When you archive files, you combine all files and directories into one file (e.g., backup.tar). This process is called archiving. Once created, the archive can be compressed (for example, to backup.tar.gz) to reduce the storage space needed. Finally, copying the compressed file to a remote location adds an extra layer of protection to your data.

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


### Archiving Files Using Tar

Tar (tape archive) was originally developed for backing up files to magnetic tapes. Although magnetic tapes are less common now, tar remains a critical tool because of its efficient way of packing and unpacking files.

#### tar --create --file archive.tar file1

#### gzip archive.tar

#### gzip --keep archive.tar

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


Tar works by combining multiple files and directories into a single file, commonly known as a tarball. This technique simplifies file transfers, uploads, or downloads, as you are working with a single file instead of many.

Consider an existing archive file named archive.tar on your system. You can view its contents using any of these commands:

## $ tar --list --file archive.tar
    file1
    file2
    file3

## $ tar -tf archive.tar
    file1
    file2
    file3

## $ tar tf archive.tar
    file1
    file2
    file3

While the shorthand version (tar tf archive.tar) is quick to type, using the longer options like —list can be more intuitive for beginners.

Always include the -f option immediately before specifying the tar file name. This practice ensures that tar correctly identifies the subsequent argument as the archive file, preventing potential misinterpretations of your options.

## Common Tar Commands

Below are some frequently used tar commands:

### Archive a Single File

To archive a single file (file1) into archive.tar:

#### $ tar --create --file archive.tar file1

This command can be shortened to:

#### $ tar cf archive.tar file1

Append a File to an Existing Archive

To add another file (file2) to your existing archive:

#### $ tar --append --file archive.tar file2

Archive an Entire Directory

To archive a directory such as Pictures/ along with its contents:

#### $ tar --create --file archive.tar Pictures/

When using a relative path (e.g., Pictures/), the archive retains the same folder structure.

Alternatively, using an absolute path:

#### $ tar --create --file archive.tar /home/aaron/Pictures/

will store the absolute path in the archive.

Before extracting files from an archive, it’s recommended to list its contents to review the directory structure. For example:

#### $ tar --list --file archive.tar

    Pictures/
    Pictures/family_dog.jpg

Extraction recreates the archived paths relative to your current directory:

#### $ tar --extract --file archive.tar

If you are in the /home/aaron/work directory, the extraction will produce:

    /home/aaron/work/Pictures/
    /home/aaron/work/Pictures/family_dog.jpg

To extract files into a different directory, use the -C option. For instance, if you’re in /home/errand and want to extract archive.tar’s contents to /tmp, run:

#### $ tar --extract --file archive.tar --directory /tmp/

Or using the shorthand version:

#### $ tar xf archive.tar -C /tmp/

Tar archives store file permissions and ownership information. If you extract files archived with a different user, you might not preserve the original ownership unless you run the command with elevated privileges (using sudo).

ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/Archive-Backup-Compress-Unpack-and-Uncompress-Files$ ls
'Archiving(Packing)-Compressing-and-Backup-1.png'
'Archiving(Packing).png'
 Packing-Files-and-Directories-with-tar-1.png
 Packing-Files-and-Directories-with-tar-2.png
 Packing-Files-and-Directories-with-tar-3.png



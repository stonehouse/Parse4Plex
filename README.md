## Plex Name Parser ##
This is very very early, but the general idea is to have a command-line tool to quickly rename files with which Plex has trouble.

### How to... ###
```bash
parse4plex --parse ~/Movies
```
NOTE: Calling without parse will show all changes without actually executing them

#### Current State ####
- Works with Super Rugby games...
- Searches for .mp4/.avi files in a given directory

#### TODO ####
- Common movie title convention parsing
- Common TV show convention parsing

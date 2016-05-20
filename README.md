## Plex Name Parser ##
[![Build Status](https://travis-ci.org/egosapien/Parse4Plex.svg?branch=master)](https://travis-ci.org/egosapien/Parse4Plex) [![Test Coverage](https://codeclimate.com/github/egosapien/Parse4Plex/badges/coverage.svg)](https://codeclimate.com/github/egosapien/Parse4Plex/coverage)

This is very very early, but the general idea is to have a command-line tool to quickly rename files with which Plex has trouble.

### How to... ###
```bash
parse4plex --parse ~/Movies
```
NOTE: Calling without parse will show all changes without actually executing them

#### Current State ####
- Works with Films
- Searches for .mp4/.avi files in a given directory
- The film parser checks IMDB, so to avoid unnecessary network traffic it only runs in directories with 'Movies' in the path.

#### TODO ####
- Better parsing for different file name conventions
- TV Show name parsing.

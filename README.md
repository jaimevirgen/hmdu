# hmdu
### how many days until ...

Shell Utility in Bash to keep track of Calendar Events

## Installation

### Dependencies
GNU Core Utils
```
brew install coreutils
```

### Add to script directory's path to your .bash_profile
```bash
export PATH=$PATH:path/to/script
```


## HMDU
```bash
# will return all events
hmdu 

# add new event
hmdu -a christmas,20161225

# list 'christmas' event countdown
hmdu christmas

# delete event
hmdu -d christmas
```

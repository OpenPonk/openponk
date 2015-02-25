DynaCASE
========


 - 1. install GitFileTree
```
Gofer new
  url: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo30/main';
  configurationOf: 'GitFileTree';
  loadDevelopment.
```

- 2. clone git repo
```
git clone git@github.com:dynacase/dynacase.git /my/path/to/dynacase
```

- 3. load project from local repo
```
Metacello new
    baseline: 'DynaCASE';
    repository: 'gitfiletree:///my/path/to/dynacase/repository';
    load.
```

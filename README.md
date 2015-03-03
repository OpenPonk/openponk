DynaCASE
========


- 1. clone git repo
```
git clone git@github.com:dynacase/dynacase.git /my/path/to/dynacase
```

 - 2. install GitFileTree & load project
```
Gofer new
	url: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo30/main';
	configurationOf: 'GitFileTree';
	loadDevelopment.

Metacello new
	baseline: 'DynaCASE';
	repository: 'gitfiletree:///my/path/to/dynacase/repository';
	load.
```
Windows note: Use forward slashes (/) even on Windows. For example
```
    repository: 'gitfiletree:///C:/Users/Username/Pharo/dynacase/repository';
```

DynaCASE
========

Pharo 4.0 is not frozen yet, thus using latest image may result in unexpected errors.

Try using **40500** (2015-02-23 18:13) (http://files.pharo.org/image/40/40500.zip)


- 1. clone git repo
```
# for read-only
git clone https://github.com/dynacase/dynacase.git /my/path/to/dynacase

# for read-write
git clone git@github.com:dynacase/dynacase.git /my/path/to/dynacase
```

 - 2. install GitFileTree & load project

NOTE that you should point Metacello to `repository` subfolder, not the root folder.
 
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

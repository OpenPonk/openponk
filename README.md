# DynaCASE

## For non-development

```
Metacello new
    baseline: 'DynaCASE';
    repository: 'github://dynacase/dynacase/repository';
    load.
```

## For development

For development purposes you need to have local git repository:

- 1. clone git repo (make sure it's `git@github` and not `https://...`)
```
# for read-write
git clone git@github.com:dynacase/dynacase.git /my/path/to/dynacase
```

 - 2. install GitFileTree & load project

NOTE that you should point Metacello to `repository` subfolder, not the root folder.

```
"install GitFileTree"
Gofer new
	url: 'http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo40/main';
	configurationOf: 'GitFileTree';
	loadDevelopment.

"(optional) lock local version of DynaCASE model (if you need to make modifications to it)"
"to get DynaCASE model for R/W clone it from here https://github.com/dynacase/dynacase-model"
"
Metacello new
	baseline: 'DynaCASEModel';
	repository: 'gitfiletree:///my_path_to_dynacase_model/repository';
	lock.
"

"load DynaCASE"
Metacello new
	baseline: 'DynaCASE';
	repository: 'gitfiletree:///my_path_to_dynacase/repository';
	"onConflict: [ :ex | ex allow ];" "required only if overriding packages"
	load.
```

Windows note: Use forward slashes (/) even on Windows. For example
```
    repository: 'gitfiletree:///C:/Users/Username/Pharo/dynacase/repository';
```

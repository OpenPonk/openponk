I am a modified PragmaMenuBuilder that also ensures that only menus for a particular plugin are retrieved.

Example:

```
OPPragmaPluginMenuBuilder pragmaMultiKeyword: #opProjectSubmenu model: self 
```

Will retrieve all menus with <opProjectSubmenu> or <opProjectSubmenu: #arg> pragmas.

For the argumented version a test will be performed. The test is currently hardcoded in `#testBlockFor:` method.

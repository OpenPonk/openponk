# OpenPonk Modeling Platform

[![Nightly](https://github.com/OpenPonk/openponk/actions/workflows/nightly.yml/badge.svg)](https://github.com/OpenPonk/openponk/actions/workflows/nightly.yml) [![Coverage Status](https://coveralls.io/repos/github/OpenPonk/openponk/badge.svg?branch=master)](https://coveralls.io/github/OpenPonk/openponk?branch=master)

Core of the [OpenPonk](https://openponk.org) metamodeling platform and diagram workbench built in [Pharo](https://pharo.org) (Spec2 workbench GUI, Roassal3 diagram rendering, ViewModel/Controller/DiagramElement layers, persistence, and Undo/Redo).

## Download

Pre-built portable desktop archives (all plugins or individual notations for Windows, Linux, and macOS) are available at [openponk.org/#download](https://openponk.org/#download).

## Installation

See [openponk.org/#direct-installation](https://openponk.org/#direct-installation) for the supported Pharo version and all-in-one installation (`OpenPonkPlugins`).

To load only the core platform into Pharo:

```smalltalk
Metacello new
	baseline: 'OpenPonk';
	repository: 'github://OpenPonk/openponk';
	load.
```

## Developer Documentation & Contributing

- **Architecture & repository catalog:** [`OpenPonk/.github`](https://github.com/OpenPonk/.github/blob/main/profile/README.md)
- **Contributing guide:** [`CONTRIBUTING.md`](https://github.com/OpenPonk/.github/blob/main/CONTRIBUTING.md)
- **Website & contact:** [openponk.org](https://openponk.org)

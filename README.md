# The OpenPonk Modeling Platform
[![Nightly](https://github.com/OpenPonk/openponk/actions/workflows/nightly.yml/badge.svg)](https://github.com/OpenPonk/openponk/actions/workflows/nightly.yml)  [![Coverage Status](https://coveralls.io/repos/github/OpenPonk/openponk/badge.svg?branch=master)](https://coveralls.io/github/OpenPonk/openponk?branch=master)

OpenPonk is a metamodeling platform and a modeling workbench implemented in the dynamic environment [Pharo](https://pharo.org) aimed at supporting activities surrounding software and business engineering such as modeling, execution, simulation, source code generation, etc.

For more information see https://openponk.github.io/

Showcase video:

[![OpenPonk](http://img.youtube.com/vi/_gQgXdJyr-0/0.jpg)](https://www.youtube.com/watch?v=_gQgXdJyr-0)


## Installation

### Prepared package

List of prepared Pharo VMs with specific OpenPonk plugins can be found [on the official website](https://openponk.org/#download).

Once downloaded, just extract and run openponk-XXX, where XXX is the suffix for the plugin set you downloaded.

### Installation from source

To install from source, follow these steps:

1. Clone this repository, optionally also clone OpenPonk plugins that you are interested in.
2. Download Pharo VM appropriate for your platform from [Pharo's official website](https://pharo.org/download). Then install it (or extract it, if you downloaded standalone version (in which case you will also need to download the "Pharo Image")).
3. Once your Pharo VM is running, navigate to Iceberg Repositories ("Browse" > "Iceberg", Ctrl+O+I)
4. Click the Add button (green plus on the right top side Iceberg's Repositories window). Select "Import from existing clone" and navigate to location you cloned this repository to. Click Ok to add the repository to the repository list.
5. Right click newly added repository (the status will be "Not loaded") and select "Metacello" > "Install baseline of ... (Default)". If there are conflicts ("Duplicated project! There is already a project XXX in this installation.") select "Use LOADED version YYY".
6. Repeat steps 4 and 5 for each OpenPonk plugin you wish to load.

Now you should see OpenPonk and your selected plugins on the top Pharo menu bar.

## Contribution

After you made changes, open Iceberg Repository window ("Browse" > "Iceberg", Ctrl+O+I).

You will see that the package you made changes in has status "Uncommited changes".

Create new branch describing the feature you worked on (right click > "Checkout branch").

Commit the changes (right click > "Commit") (you will be able to review the changes before actually commiting).

Then push to your fork of the origin and make a pull request (from GitHub).


<h1 align="center">Trailhead Permission Sets for Unlocked Packages Project</h1>
This project contains the sample custom objects and custom tab for the Trailhead project 'Packaging Permission Sets with Salesforce DX'. The objective of this training is to show the trailblazer how to create and package a custom permission set using Salesforce DX CLI and working with Unlocked Packages.

===========================
#### Contents:
- [Tools](#tools) 
- [Resources](#resources)

===========================
#### Tools
|  Tool:       |  Version:  |
| ------------ | ---------- |
| **SFDX-CLI** | [![npm](https://img.shields.io/npm/v/sfdx-cli.svg?label=SFDX-CLI&logo=Salesforce&style=Popout)](https://developer.salesforce.com/tools/sfdxcli)  |

===========================
## The Project Overview

### Set Up the Salesforce DX Project
Our first goal is to set up a developer project which we'll use to modify our application. It starts by cloning the repository. Use the command ...
```
git clone https://github.com/developerforce/PermSetUnlockedPackage
```
… or ...
```
git clone git@github.com:developerforce/PermSetUnlockedPackage
```
… to clone the repository. Then, open the directory.
```
cd PermSetUnlockedPackage
```
### Authorize Dev Hub in your Trailhead Playground
Log into your Dev Hub org.
```
sfdx force:auth:web:login -d -a DevHub
```
Proceed to log in with your dev hub credentials.

If you already have an authorized Dev Hub, set it as the default:
```
sfdx force:config:set defaultdevhubusername=<username|alias>
```
### Create a scratch org
```
sfdx force:org:create -s -f config/project-scratch-def.json
```
### Push the source to your scratch org
```
sfdx force:source:push
```
### Open the scratch org and make some changes.
```
sfdx force:org:open
```
### Pull the changes
```
sfdx force:org:pull
```
### Create a new Package Version
```
sfdx force:package:version:create -p packageName -d force-app -k test1234 --wait 10 -v DevHub
```

After installing the package into a scratch org and testing it out, next you release the package!
```
sfdx force:package:version:promote -p packageName@1.0.0-1 -v DevHub
```

===========================
### Resources
For details on using sfdx-simple, please review the [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev).

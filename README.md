# Automating migration of Enterprise Guide to SAS Viya with CICD pipelines in github

Many are now considering migrating Enterprise Guide projects to SAS Viya. This work can be tedious and requires tight attention to details.

And as humans we are not always good at that – we get bored and sloppy, and mistakes may happen.

So why not automate this and have a computer do this for us? With CICD and devops being a thing, doing migration through CICD seems to be a sensible way of attacking this. Also – many of the tools for migration are well suited for automation – most of them have command-line options.

And as a CICD addict and true believer in all things agile, going cicd on migration makes a ton of sense.

This repository have content and guidance on:

* Understanding and setting up the environments to prepare for CICD
* How to use git to transfer content between SAS94 and SAS Viya
* Using github actions to automate importing and validation of sas content to SAS Viya

The approach works similarly in gitlab, Azure Devops and other git management platforms – as the concepts for managing the CICD pipelines are quite similar. 

## Understanding and setting up the environments to prepare for CICD
![Overview](images/github%20overview.jpg)

To be able to follow this approach, you would need access to a SAS94 environment as well as a SAS Viya environment.

The SAS 94 environment would need the following set of tools:

* SAS Management console - provides a way to understand how libraries are set up, in our case we are using it to find out where the SAS datasets being used resides physically, and also changed the name to deal with a current bug in the migration process
* SAS Enterprise Guide - we want to import a flow from one Enterprise Guide project as well as take advantage of a fairly user friendly and SAS friendly user interface to git inside Enterprise Guide
* Git locally installed
* Use of windows explorer to copy files between folders

The content in this repository focuses on content migration - data migration may very well be covered in another repo later - all kinds of interesting topics to cover; like conversion of encoding, migrating to different types of data sources, and latency when moving data. In this example, we simply copied the data sets as files from the SAS94 environment to the SAS Viya environment.

See the following picture for how to get the physical location of the SAS library we want to work with.
![SAS Management%20Console%20with%20library%20definition](images/SAS%20Management%20Console%20-%20libname.jpg)

We are using git as a way of transferring test data and expected results to the SAS Viya environment - for the purpose of validation.

In Enterprise Guide we will work with the flow we want to get to SAS Viya - see below:
![Enterprise%20Guide%20flow%20to%20import](images/SAS%20EG%20project.jpg)

This Enterprise Guide project (Financial_Master_v1) is already saved to the repo, and if you want to follow this example, I would recommend that you simply load this. 

# Data Hub Setup for CG Expert Finder

This repo should be used to setup the directory that will be used to house and run the Data Hub project that's used for ingesting and harmonising data in the **CG Expert Finder** application.

## Contents

This `cg-ef-datahub` directory will contain two directories: `/input` and `/plugins`.

The `/plugins` folder contains the Ingest and Harmonise routines that we will use within the Data Hub.

The `/input` folder contains subfolders for each source data file that will be ingested using Data Hub. Also contained here, you will find a number of `_BLANK.csv` files -- these are placeholders for the actual source data files that you will be ingesting. Replace the `_BLANK.csv` files with the actual source CSV files.

**IMPORTANT:** You must ensure that your actual source CSV files have the same structure as the `*anon*.csv` input files provided in this repository.

## Instructions

**NOTE ON FOLDER STRUCTURE:** If you want to mirror the directory structure of the original CG Expert Finder project, first setup a new base directory (ie `/cg-expertfinder`) that will contain both the Data Hub project and the Slush (frontend UI) project. For example, you would end up with something like...

    /Users/jsmith/Projects/cg-expertfinder
        /cg-ef-datahub
        /cg-ef-slushapp
**...**

Unzip or clone this **cg-ef-datahub** repo onto your local machine. You will now have a `/cg-ef-datahub` folder with the contents described above.

You can replace the `*anon*.csv` input files with your actual source CSV files, as described above, making sure they have the same structure.

Download the latest [v1 Quick Start application](https://github.com/marklogic-community/marklogic-data-hub/releases) from Releases section of the [MarkLogic Data Hub repository](https://github.com/marklogic-community/marklogic-data-hub). Place the Quick Start `.war` file into the same `/cg-ef-datahub` folder.

Start up the Quick Start (Java) application using the `java -jar quick-start-1****.war` command (replace **** with your actual file name).

Open a browser and run the Quick Start application. This will step you through configuring a new Data Hub environment...

- First, click Browse and select your `cg-ef-datahub` directory as the Project Folder.
- Quick Start will then want to initialise the project
- Provide a DataHub Name -- you can use the default `data-hub` or something more specific `cg-ef-datahub` -- this will be used as the naming prefix for all of the MarkLogic databases created for the Data Hub (ie, cg-ef-datahub-STAGING, cg-ef-datahub-FINAL, etc.)
- Provide the Host location of where you are running MarkLogic -- for a local MarkLogic install, simply use `localhost`
- Under Advanced Settings, you will see the config options for each MarkLogic database that will be created by the Data Hub -- you'll want to ensure that the Port numbers specified are available on your MarkLogic server -- you can leave all the other Advanced Settings unchanged
- Click the Intialize button
- You can select the default `local` Project Environment, and then click Next >
- Login to the Data Hub using your MarkLogic server credentials
- Quick Start will then ask to install the Data Hub Framework. Click INSTALL -- this will take a moment to complete
- Once the install completes, you can go to the Entities tab of the Quick Start application, and you should be able to see the expected Entities, Input and Harmonize Flows.

At this stage, you are ready to ingest the source data into the MarkLogic Data Hub Framework. Assuming you have your source data CSV files in the correct `/input` folder locations, you can then run the Input Flows to bring the source data into the STAGING database, and then run the "Employee" Harmonize Flow to merge and move data into the FINAL database.

## Next Steps

Setup the frontend search application using [MarkLogic's Slush generator](https://github.com/marklogic-community/slush-marklogic-node).

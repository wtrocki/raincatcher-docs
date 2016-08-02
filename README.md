# Documentation Repository

* Review the [repository structure](#repository-structure)
* [Use this repository template](#use-this-repository-template) as a starting point for your project.

## Repository Structure Overview

This repository contains all of the documentation for XYZ product name. It uses the following directory structure:

.  
├── README.md (This file)  
├── docs (This folder contains all the asciidoc topics and top level content spec)  
│   ├── My_Title_A  
│   │   ├── master.adoc  
│   │   ├── master-docinfo.xml  
│   │   ├── buildGuide.sh (script to build this guide)  
│   │   ├── topics -> ../topics/ (symlink to docs/topics/)  
│   ├── My_Title_B  
│   │   ├── master.adoc  
│   │   ├── master-docinfo.xml  
│   │   ├── buildGuide.sh (script to build this guide)  
│   │   ├── topics -> ../topics/ (symlink to docs/topics/)  
│   ├── My_Title_C  
│   │   ├── master.adoc  
│   │   ├── master-docinfo.xml  
│   │   ├── buildGuide.sh (script to build this guide)  
│   │   ├── topics -> ../topics/ (symlink to docs/topics/)  
│   ├── topics  
│   │   │   ├── images (This folder contains all the images)  
│   │   │   │   ├── *.png  
│   │   │   ├── *.adoc (AsciiDoc topic files)  
├── internal-resources (Place any content useful for the writing team here, for example, style guides, how-tos)  
└── scripts (Contains scripts to automate the processes used to create and build documentation)  
    └── buildGuides.sh (Builds the top-level Guides that live in the docs/ folder)  


## Use this Repository Template

Clone this repository to your local machine. You may want to build the books in this example repository and review the output to understand how it works before you make any changes. 

### Build the Example Books

To build all of the example books, open a terminal, navigate to the root directory of this repository, and type the following command:

        $ scripts/buildGuides.sh

The script provides links to both AsciiDoctor and ccutil builds for each of the example books. Look at the rendered HTML to see how the preprocessor directives work to conditionally display content.

You can also build a single guide. Navigate to the folder of the book you want to build and type the following command:

        $ ./buildGuide.sh

### Modify the Example Books for Your Documentation

Copy the structure into your own local repository and make the following changes to customize this template for your implementation.

1. Add your Asciidoc `*.adoc` files to the `topics/` folder.
2. Replace the values in the `docs/topics/document-attributes.adoc` file for your documentation.
  * Replace the product names and releases.
  * Replace the book names.
3. Use 'git mv' to rename the book folder names.

        $ cd My_Title_A
        $ git mv My_Title_A Installation_Guide.
4. In a terminal, navigate to each book folder and add the symlink to the `topics/` using this command:

        $ ln -s ../topics topics
5. Within each book folder, modify the `master-docinfo.xml` file to set the appropriate title, product, release, and other values for the build of the book to the portal.
6. Within each book folder, modify the `master.adoc` file to set the appropriate title, document attributes, and include the appropriate `topics/` content.
7. When you are ready, run the scripts to build the guides and review the output to make sure it looks correct.

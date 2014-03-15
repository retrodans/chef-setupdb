chef-setupdb Cookbook
==================
This cookbook uses the information from your data-bags/sites/xxxx.json file to generate databases, create users, and import sql data from your local sites


Requirements
------------
This cookbook was built and tested using the base setup below

#### Base Setup
- vagrant-lamp This cookbook was built to integrate with the setup from the https://github.com/r8/vagrant-lamp repo
- Ubuntu host OS

#### Other Cookbooks
- mysql
- database


Attributes
----------
There are no attributes in this cookbook yet


Usage
-----
#### chef-setupdb::default
Add this cookbook, and run it in your regular run_list (I added after the other cookbooks in my vagrantfile).  You can then modify the sites/xxxxx.json files accordingly

```json
{
    "id": "<siteid>",
    "host": "<sitehostname>",
    "docroot": "<sitedocroot>",
    "aliases": [
        "<sitealiases>"
    ],
    "dbname": "<sitedbname>",
    "dbuser": "<sitedbuser>",
    "dbuserpass": "<sitedbpass>",
    "dbpath": "<sitedbpath>"
}
```

Contributing
------------
Whilst this wasn't intended for public use and contributing.  I am happy to receive input if others would like to use this cookbook too.  I am just sticking to the default process below for receiving update requests.

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Authors
-------------------
Authors: Dan Duke (@retrodans)

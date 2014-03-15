#
# Cookbook Name:: chef-setupdb
# Recipe:: default
#
# Copyright 2014, Retrobadger Digital Projects
#
# All rights reserved - Do Not Redistribute
#
include_recipe "mysql"
include_recipe "database::mysql"

# Setup mysql connection variables
mysql_connection_info = {
    :host => "localhost",
    :username => 'root',
    # automatically get this from the override_attributes call!
    :password => node['mysql']['server_root_password']
}

# Initialize sites data bag
sites = []
begin
  sites = data_bag("sites")
rescue
  puts "Unable to load sites data bag."
end


# Setup databases for each site
sites.each do |name|

  site = data_bag_item("sites", name)

  # Setup DB for this site if required
  if !site["dbname"].nil? && !site["dbpath"].nil?

    # Setup DB variables
    dbname = site["dbname"]
    dbpath = site["dbpath"]
    site["dbuser"].nil? ? dbuser = "root" : dbuser = site["dbuser"]
    site["dbuserpass"].nil? ? dbuserpass = "vagrant" : dbuserpass = site["dbuserpass"]

    # Create DB user
    database_user dbuser do
      connection mysql_connection_info
      password   dbuserpass
      provider   Chef::Provider::Database::MysqlUser
      action     :create
    end

    # THIS SHOULD NOT RUN IF DB ALREADY EXISTS
    # As several commands have the same restriction, I am wrapping in an if statement rather than using the not_if xxxxxx
    # backticks and bash scripts: http://rubyquicktips.com/post/5862861056/execute-shell-commands
    if `mysql -u root -p\"#{node['mysql']['server_root_password']}\" -e "SHOW DATABASES" | grep '#{dbname}'` != ""
      # The table exists
      puts "DB: The DB #{dbname} already exists, so will not recreate/wipe"
    else
      # the table does not exist
      puts "DB: The DB #{dbname} does not yet exist"
    
      # create empty database
      mysql_database dbname do
        connection mysql_connection_info
        action :create
        puts "DB: database #{dbname} will be created"  
      end

      # Give user required priviledges
      mysql_database_user dbuser do
        connection    mysql_connection_info
        password      dbuserpass
        database_name dbname
        host          '%'
        #privileges    [:select,:update,:insert,:delete,:create,:drop,:index,:alter,:lock_tables,:create_temporary_tables]
        action        :grant
        puts "DB: user #{dbuser} will be given permissions for #{dbname}"
      end

      # Import data into the DB
      # Import DB from an sql file
      execute "import" do
        command "mysql -u root -p\"#{node['mysql']['server_root_password']}\" #{dbname} < /vagrant/public/#{dbpath}"
        action :run
        puts "DB: data will be imported into #{dbname}"
      end

    end

  end

end
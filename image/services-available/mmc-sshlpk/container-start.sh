#!/bin/bash -e

include /path/to/openldap/schema/ppolicy.schema
...
# Load the ppolicy module
moduleload  ppolicy
...
# Add the overlay ppolicy to your OpenLDAP database
database  bdb
suffix    "dc=mandriva,dc=com"
...
overlay ppolicy
ppolicy_default "cn=default,ou=Password Policies,dc=mandriva,dc=com"

ppolicyDN
name             'tinc'
maintainer       'Christophe Courtaut'
maintainer_email 'christophe.courtaut@gmail.com'
license          'All rights reserved'
description      'Installs/Configures tinc-cookbook'
long_description 'Installs/Configures tinc-cookbook'
version          '0.1.6'

grouping 'tinc',
 :title => 'Tinc Options',
 :description => 'The various options to get tinc configured properly'

attribute 'tinc/network_name',
  :display_name => "Tinc Network name",
  :description => "The Tinc network name to be part of",
  :type => "string",
  :required => "recommended",
  :recipes => [ 'tinc::config' ],
  :default => "default"

attribute 'tinc/listen_po',
  :display_name => "Tinc listen port",
  :description => "The port the Tinc network daemon will listen to",
  :type => "string",
  :required => "optional",
  :recipes => [ 'tinc::config' ],
  :default => "default"

version_bumper
==============

Simple. Bump your versions.

What is it for?
---------------
Given that we agree upon a [version format][1], maintain a version for your project. The version is kept in a file, in the root of your project, which is a common thing to do.  
Especially useful for developers using rake as their build runner in non-ruby projects (don't you?).



Quick start
-----------
    $ gem install version_bumper

First lets agree that version looks like this: major.minor.revision.build  
In your `Rakefile` `require 'version_bumper'` and you're done. If you're in rails, `gem 'version_bumper'` to your `Gemfile` in addition.
  
    $ rake -T
    rake bump:init      # write a blank version
    rake bump:major     # bump major
    rake bump:minor     # bump minor
    rake bump:patch     # bump patch or bump patch[tag]
    rake bump:build     # bump build
    
    $ rake bump:init
    version: 0.0.0.0
    $ rake bump:build
    version: 0.0.0.1
    $ rake bump:patch
    version: 0.0.1.0
    $ rake bump:minor
    version: 0.1.0.0
    $ rake bump:major
    version: 1.0.0.0
    

You can optionally use `bumper_file 'version.txt'` in your rake file to switch from the default `VERSION` file name.
Use `bumper_version` anywhere you need access to the current version in your rake script.

Pre-release versioning
----------------------

You can append a hyphen tag to the *patch* version, e.g., 1.0.0-alpha, 1.0.0-beta, 1.0.0-beta2, 1.0.0-gamma, 1.0.0-rc, 1.0.0-rc2, etc.

Or you can prepend a tag to the *build* version, e.g., 1.0.0.alpha1, 1.0.0.beta1, 1.0.0.rc3, etc.

    $ rake bump:init
    version: 0.0.0.0
    $ rake bump:minor
    version: 0.1.0.0
    $ rake bump:patch[beta]
    version: 0.1.1-beta.0
    $ rake bump:patch[beta]
    version: 0.1.1-beta2.0
    $ rake bump:build
    version: 0.1.1-beta2.1
    $ rake bump:patch[rc]
    version: 0.1.1-rc.0
    $ rake bump:patch[rc]
    version: 0.1.1-rc2.0
    $ rake bump:patch
    version: 0.1.1.0
    $ rake bump:patch
    version: 0.1.2.0
    $ rake bump:minor
    version: 0.2.0.0
    $ rake bump:build[beta]
    version: 0.2.0.beta1
    $ rake bump:build
    version: 0.2.0.beta2
    $ rake bump:build[rc]
    version: 0.2.0.rc1
    $ rake bump:patch[alpha]
    version: 0.2.1-alpha.0

Contributing to version_bumper
------------------------------
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Commiters
---------
jondot (Dotan Nahum)  
splattael (Peter Suschlik)  
derickbailey (Derick Bailey)  
drh-stanford (Darren Hardy)  


Copyright
---------

Copyright (c) 2011 Dotan Nahum. See LICENSE.txt for
further details.



[1]: http://semver.org

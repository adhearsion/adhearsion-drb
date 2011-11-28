ahn-drb
=======

ahn-drb is an Adhearsion Plugin providing DRb connectivity.

Features
--------

* FIXME (list of features and unsolved problems)

Requirements
------------

* Adhearsion 2.0+

Install
-------

Add `ahn-drb` to your Adhearsion app's Gemfile.

Configuration
-------------

In your Adhearsion app configuration file, add the following values:

```ruby
Adhearsion.config[:ahn_drb] do |config|
  config.host = "DRb service host"
  config.port = "DRB service port".to_i
  config.acl.allow = ["127.0.0.1"] # list of allowed IPs (optional)
  config.acl.deny = [] # list of denied IPs (optional)
end
```

Author
------

Original author: [Juan de Bravo](https://github.com/juandebravo)

Links
-----
* [Source](https://github.com/adhearsion/ahn-drb)
* [Documentation](http://rdoc.info/github/adhearsion/ahn-drb/master/frames)
* [Bug Tracker](https://github.com/adhearsion/ahn-drb/issues)

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  * If you want to have your own version, that is fine but bump version in a commit by itself so I can ignore when I pull
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Check [License file](https://github.com/adhearsion/ahn-drb/blob/master/LICENSE)
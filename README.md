adhearsion-drb
=======

adhearsion-drb is an Adhearsion Plugin providing DRb connectivity. It allows third party ruby clients to connect to an Adhearsion instance for RPC.

Requirements
------------

* Adhearsion 2.0+

Install
-------

Add `adhearsion-drb` to your Adhearsion app's Gemfile.

Configuration
-------------

In your Adhearsion app configuration file, add the following values:

```ruby
Adhearsion.config[:adhearsion_drb] do |config|
  config.host = "DRb service host"
  config.port = "DRB service port".to_i
  config.acl.allow = ["127.0.0.1"] # list of allowed IPs (optional)
  config.acl.deny = [] # list of denied IPs (optional)
  config.shared_object = some_shared_object
end
```

The `shared_object` in the config is the endpoint to which a 3rd-party client will be bound on connection. The most basic scenario looks something like this:

```ruby
class DrbEndpoint
  def foo
    :bar
  end
end

Adhearsion.config.adhearsion_drb.shared_object = DrbEndpoint.new
```

with the following client:

```ruby
require 'drb'
adhearsion_api = DRbObject.new_with_uri 'druby://localhost:9050'
p adhearsion_api.foo
```

When the Adhearsion application is running, and the client script runs, it should print `:foo` to stdout.

A more useful example to return the number of active calls:

```ruby
class DrbEndpoint
  def call_count
    Adhearsion.active_calls.count
  end
end
```

Or to trigger an outbound call:

```ruby
class DrbEndpoint
  def call(number, provider)
    Adhearsion::OutboundCall.originate "SIP/#{number}@#{provider}", controller: FooController
  end
end
```

Author
------

Original author: [Juan de Bravo](https://github.com/juandebravo)

Links
-----
* [Source](https://github.com/adhearsion/adhearsion-drb)
* [Documentation](http://rdoc.info/github/adhearsion/adhearsion-drb/master/frames)
* [Bug Tracker](https://github.com/adhearsion/adhearsion-drb/issues)

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

Copyright (C) 2012 Adhearsion Foundation Inc.
Released under the MIT License - Check [License file](https://github.com/adhearsion/adhearsion-drb/blob/master/LICENSE)

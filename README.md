The Blob
=====

The Blob is a memory based instance storage system.

#Adding to your app

```ruby
require 'the_blob'

class YourAppClass
  include TheBlob
end
```

Put your instances in the app/instances folder and they will be automatically loaded.

#Instances

Instances are data structures. Try to keep logic out of them or you might as well use Rails.

```ruby
class YourInstance < Instance
  attr_accessors :foo, :bar
  instance_indices :index
end
```

#Inserting instances

```ruby
app = YourAppClass.new
app.absorb YourInstance.new(index: "foobar")
```

#Retrieving instances

```ruby
app.emit_your_instance_by_index "foobar"
#=> your_instance

# Or a realish world example
app.emit_user_by_email "foo@bar.com"
#=> user
```

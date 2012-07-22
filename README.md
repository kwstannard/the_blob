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

class User < Instance
  instance_indices :email
end
```

#Inserting instances

```ruby
app = YourAppClass.new
app.absorb YourInstance.new(index: "foobar")

app.absorb User.new(email: "foo@bar.com")
```

#Retrieving instances

```ruby
app.emit_your_instance_by_index "foobar"
#=> your_instance

app.emit_user_by_email "foo@bar.com"
#=> user
```

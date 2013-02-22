This is common test stuff that can be used by Ruby apps.

Tasks
-----

To include tasks, add a Rakefile to your project containing the following:

  require 'bengler_test_helper/tasks'

This adds:

* `rake db:structure:load`: Loads test database with schema from `db/development_structure.sql`.

Also, it overrides Rails' default tasks:

* `rake db:migrate`: Automatically saves schema to `db/development_structure.sql`
  by invoking `db:structure:dump`.
* `rake db:test:prepare`: Instead of dumping schema from development database,
  it loads bootstrap data form `db/bootstrap.sql` and uses `db:structure:load`.

For non-Rails projects, the following Rails-compatible tasks are provided:

* `rake db:structure:dump`: Saves schema to `db/development_structure.sql` like
   you would expect.

This is common test stuff that can be used by Ruby apps.

Tasks
-----

To include tasks, add a Rakefile to your project containing the following:

    require 'bengler_test_helper/tasks'

This adds:

* `rake db:test:load_bootstrap`: Loads bootstrap data from `db/bootstrap.sql` if it exists.
* `rake db:test:load_structure`: Loads test database with schema from `db/development_structure.sql`.

Also, it overrides Rails' default tasks:

* `rake db:test:prepare`: Instead of dumping schema from development database, 
   it uses `db:test:load_structure` and `db:test:load_bootstrap`.
* `rake db:migrate`: Automatically saves schema to `db/development_structure.sql`
   by invoking `db:structure:dump`.

For non-Rails projects, the following Rails-compatible tasks are provided:

* `rake db:structure:dump`: Saves schema to `db/development_structure.sql` like
   you would expect.

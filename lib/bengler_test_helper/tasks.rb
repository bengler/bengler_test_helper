unless defined?(Rake)
  require 'rake'
end

Rake::TaskManager.class_eval do
  unless method_defined?(:remove_task)
    def remove_task(task_name)
      @tasks.delete(task_name.to_s)
    end
  end
end

Rake.application.remove_task :"db:test:prepare"
Rake.application.remove_task :"db:structure:dump"

require 'bengler_test_helper/active_record'

require 'bengler_test_helper/tasks/rails_db_test_prepare'
require 'bengler_test_helper/tasks/rails_db_bootstrap_data'
require 'bengler_test_helper/tasks/rails_db_load_structure'
require 'bengler_test_helper/tasks/rails_db_dump_structure'
require 'bengler_test_helper/tasks/rails_dump_schema_on_migrate'

require 'rake' unless defined?(Rake)

Rake::TaskManager.class_eval do
  unless method_defined?(:remove_task)
    def remove_task(task_name)
      @tasks.delete(task_name.to_s)
    end
  end
end

begin
  # If there's no active record, we don't care.
  require 'active_record'

  Rake.application.remove_task :"db:test:prepare"
  Rake.application.remove_task :"db:structure:dump"

  require 'bengler_test_helper/active_record'
  require 'bengler_test_helper/tasks/db_migrate'
  require 'bengler_test_helper/tasks/db_structure_dump'
  require 'bengler_test_helper/tasks/db_structure_load'
  require 'bengler_test_helper/tasks/db_test_config'
  require 'bengler_test_helper/tasks/db_test_create'
  require 'bengler_test_helper/tasks/db_test_prepare'

rescue LoadError => e
  puts "We can't load ActiveRecord. That might be fine. #{e.message}"
rescue Exception => e
  puts "Bengel Tools Fail. #{e.message}."
end

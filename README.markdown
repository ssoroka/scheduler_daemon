Scheduler Daemon
================

Rails 3+ compatible scheduler daemon (see branches for older versions).

Replaces cron/rake pattern of periodically running rake tasks 
to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app, 
and only loads the environment once, no matter how many tasks run.

What's so great about it?  Well, I'm glad you asked!

- Only loads your Rails environment once on daemon start, not every time a task is run
- Allows you to easily deploy the scheduled tasks with your Rails app instead of depending on an
  administrator to update crontab
- Can be installed as a gem or a plugin (I suggest gem)
- It doesn't use rake or cron!
- Gets you up and running with your own daemon in under 2 minutes
- Specially designed to work with your rails app!

Setup
=====

Install as a gem or plugin.

As a gem, the old-fashioned way:

    gem install scheduler_daemon

As a gem with bundler, add to your ./Gemfile:

    gem 'scheduler_daemon'
    
I pretty much assume you chose this option below and prefix most commands with "bundle exec"

As a plugin: (might be awkward to call the binary to start up the daemon...)

    script/plugin install git://github.com/ssoroka/scheduler_daemon.git
    # Install required gems
    gem install daemons rufus-scheduler eventmachine chronic -s http://gemcutter.org

Optionally generate the default scheduler daemon task for your rails app:

    script/rails generate scheduler_task MyNewTask

which will create an task named:

    scheduled_tasks/my_new_task.rb

Usage
=====

generate a new scheduled task:

    script/rails generate scheduler_task MyTaskName

If you have problems with that, the template for new tasks is in the gem under:
  
    lib/scheduler_daemon/rails/generators/scheduler_task/templates/scheduled_tasks/example_task.rb
    
you can always copy it and make modifications, or see "Manually create tasks" below.

Tasks support their own special DSL; commands are:

    environments :production, :staging             # run only in environments listed. (:all by default)
    every '1d'                                     # run every day
    every '1d', :first_at => Chronic.parse("2 am") # run every day, starting at 2 am (see caveat below)
    at Cronic.parse('5 pm')                        # run *once* at 5 pm today
                                                   #   (relative to scheduler start/restart time    )
                                                   #   (happens every time scheduler starts/restarts)
                                                   #   (see caveat below                            )
    cron '* 4 * * *'                               # cron style (run every 4 am)
    in '30s'                                       # run once, 30 seconds from scheduler start/restart

fire up the daemon in console mode to test it out

    bundle exec scheduler_daemon run

For production environments, add the daemon to the system start-up, and
capistrano deploy scripts, etc.  Something like:

    export RAILS_ENV=production
    bundle exec scheduler_daemon start

Selectively run tasks like so:

    bundle exec scheduler_daemon start -- --only=task_name1,task_name2 --except=not_me

Manually create tasks
=====================

If you don't want to use this gem with Rails, you can manually create tasks in a scheduled_tasks/ subdirectory and start the daemon with --skip-rails (though it'll figure it out anyway if there's no config/environment.rb file in the launch directory or --dir=/path)

Here's an example task file.

    class CleanUpTask < Scheduler::SchedulerTask
      every '2m'
  
      def run
        do_something
        log("I've done things")
      end
    end

Specs
=====

See the spec for session cleaner for an idea on how to write specs for your tasks

To Do
=====

Looking for suggestions!

Send requests to ssoroka78@gmail.com or on twitter, @ssoroka

Bugs
====

Submit bugs here http://github.com/ssoroka/scheduler_daemon/issues

Caveats
=======

When using the cronic gem to parse dates, be careful of how it interprets your date,
for example:

    every '24h', :first_at => Chronic.parse('noon')

will be once a day at noon, but the first time the server starts up (or restarts), noon
is relative to the current time of day.  Before lunch, and it's in the future.  If the
daemon starts up after lunch, the date is in the past, *and the task is immediately run*
because it thinks it missed its last execution time.  Depending on what your task is,
this may or may not be a problem.  If you always want the date to resolve in the future
with terms like "noon", "3 am" and "midnight", prepend "next" to it.  ie:

    every '24h', :first_at => Chronic.parse('next noon')

Author
======

Steven Soroka

* [@ssoroka](http://twitter.com/ssoroka)
* [My Github repo](http://github.com/ssoroka)
* [My blog](http://blog.stevensoroka.ca)


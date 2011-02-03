Scheduler Daemon
================

Rails 2.3+ compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks 
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

    gem install scheduler_daemon -s http://gemcutter.org

As a gem with bundler, add to your ./Gemfile:

    source "http://gemcutter.org"
    gem 'scheduler_daemon', :only => :bundle

As a plugin: (might be awkward to call the binary to start up the daemon...)

    script/plugin install git://github.com/ssoroka/scheduler_daemon.git
    # Install required gems
    gem install daemons rufus-scheduler eventmachine chronic -s http://gemcutter.org

Optionally generate the default scheduler daemon task for your rails app:

    script/generate scheduler

which will create an excellent example task named:

    lib/scheduled_tasks/session_cleaner_task.rb

Usage
=====

generate a new scheduled task:

    script/generate scheduler_task MyTaskName


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

    scheduler_daemon run

For production environments, add the daemon to the system start-up, and
capistrano deploy scripts, etc.  Something like:

    RAILS_ENV=production scheduler_daemon start

Selectively run tasks like so:

    scheduler_daemon start -- --only=task_name1,task_name2 --except=not_me

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

I'd especially like to hear about success/failures with Rails versions outside of 2.2.x to 2.3.x

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

Thanks
======

Special thanks to [Goldstar](http://www.goldstar.com) for promoting open-source in the workplace.

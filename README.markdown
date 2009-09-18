Scheduler Daemon
================

Rails 2.3.2 compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks 
to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app, 
and only loads the environment once, no matter how many tasks run.

What's so great about it?  Well, I'm glad you asked!

- Only loads your Rails environment once on daemon start, not every time a task is run
- Allows you to easily deploy the scheduled tasks with your Rails app instead of depending on an
  administrator to update crontab
- It doesn't use rake or cron!
- Gets you up and running with your own daemon in under 2 minutes

Setup
=====

Install the plugin

    script/plugin install git://github.com/ssoroka/scheduler_daemon.git

Install required gems

    gem sources -a http://gems.github.com # if you haven't already...

    sudo gem install daemons rufus-scheduler eventmachine chronic

You'll need the chronic gem if you want to be able to use english time descriptions in your scheduled tasks, like:

    every '3h', :first_at => Chronic.parse('midnight')

generate the scheduler daemon files in your rails app:

    script/generate scheduler

Usage
=====

generate a new scheduled task:

    script/generate scheduler_task MyTaskName


Tasks support their own special DSL; commands are:

    environments :production, :staging             # run only in environments listed. (:all by default)
    every '1d'                                     # run once a day
    every '1d', :first_at => Chronic.parse("2 am") # run once a day, starting at 2 am
    at Cronic.parse('5 pm')                        # run once at 5 pm, today (today would be relative to scheduler start/restart)
    cron '* 4 * * *'                               # cron style (the example is run at 4 am, I do believe)
    in '30s'                                       # run once, 30 seconds from scheduler start/restart

fire up the daemon in console mode to test it out

    ruby scheduler/bin/scheduler_daemon.rb run

When you're done, get your system admin (or switch hats) to add the daemon to the system start-up, and
capistrano deploy scripts, etc.  Something like:

    RAILS_ENV=production ruby scheduler/bin/scheduler_daemon.rb start

Run individual tasks like so:

    ruby daemons/bin/task_runner.rb run -- --only=task_name1,task_name2

Specs
=====

There are some default specs supplied, you are encouraged to write more specs for your tasks as you create them.  Use the existing spec as a template.

See spec/README for more information

To Do
=====

- dynamically add and remove tasks while daemon is running (? anyone want this?) Perhaps a web interface?

Author
======

Steven Soroka

* [@ssoroka](http://twitter.com/ssoroka)
* [My Github repo](http://github.com/ssoroka)
* [My blog](http://blog.stevensoroka.ca)

Thanks
======

Special thanks to [Goldstar](http://www.goldstar.com) for sponsoring the plugin and promoting open-sourcesness.

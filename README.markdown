Scheduler Daemon
================

Rails 2.3.2 compatible scheduler daemon.  Replaces cron/rake pattern of periodically running rake tasks 
to perform maintenance tasks in Rails apps. Scheduler Daemon is made specifically for your Rails app, 
and only loads the environment once, no matter how many tasks run.

Get up and running with your own daemon in under 2 minutes!

Setup
=====

1. Install the plugin

    script/plugin install git://github.com/ssoroka/scheduler_daemon.git

2. Install required gems

    gem sources -a http://gems.github.com # if you haven't already...

    sudo gem install daemons rufus-scheduler eventmachine

3. Add the following line to your .gitignore (you have one, right?) since logs and pids get written there.

    scheduler/log

4. script/generate scheduler

Usage
=====

5. generate a new scheduled task:

    script/generate scheduler_task MyTaskName

6. fire up the daemon in console mode to test it out

    ruby scheduler/bin/scheduler\_daemon.rb run

When you're done, get your system admin (or switch hats) to add the daemon to the system start-up, and
capistrano deploy scripts, etc.  Something like:

    ruby /path/to/rails/app/scheduler/bin/scheduler_daemon.rb start

About
=====

Steven Soroka

* [@ssoroka](http://twitter.com/ssoroka)
* [My Github repo](http://github.com/ssoroka)
* [My blog](http://blog.stevensoroka.ca)
  
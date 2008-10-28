use inc::Module::Install;

name     'Log-Log4perl-Filter-CallerMatch';
all_from 'lib/Log/Log4perl/Filter/CallerMatch.pm';
author   'Patrick Donelan <pat@patspam.com>';

build_requires 'Test::More';

auto_install;

WriteAll;


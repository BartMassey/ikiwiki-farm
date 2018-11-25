# ikiwiki-farm
Copyright (c) 2007 Bart Massey

*This is an experimental work-in-progress; use at your own risk.*

This set of files constitutes an
[ikiwiki](http://ikiwiki.info) and
[Mailman](http://www.list.org) list installer (and remover)
suitable for wiki "farming".  Wiki farming is sharing the
software and administration resources of a wiki site among
multiple hosted wikis.  A good wiki farm allows easy
creation and deletion of wikis. I've added Mailman support
so that email lists can be easily associated with the wikis
if desired.

This software is a set of shell scripts I use to maintain my
`ikiwiki` farm at
[Portland State University](http://wiki.cs.pdx.edu), which
currently contains more than 70 wikis.  My farm software is
patterned after earlier scripts I wrote when my farm was a
[TWiki](http://twiki.org) farm, but abandoned because of
TWiki security problems.

## Using

* To make a wiki (and possibly a mailman list):

  * Copy template.cnf to cnf/yourwikiname.cnf and edit it
    appropriately. Note that no checking is done on your
    .cnf file, so be careful.  When you are done, add
    your config file to the git repo there so that you can
    track changes to it.
  
  * Run "sh mkwiki.sh cnf/yourwikiname.cnf >/tmp/script".
    This will emit a shell script that will create the wiki.
    Inspect the script.
  
  * When you are ready, run "sh /tmp/script", which will do
    the work of setting everything up.

* To remove a wiki (and any associated mailman list):

    sh rmwiki.sh yourwikiname.cnf >/tmp/script
    sh /tmp/script

  Note that little sanity checking is done on removes, so be
  careful.

## Templates

The files `apache2-site.txt`, `htaccess`, `ikiwiki.setup`,
`index.mdwn` and `mailman-config` are templates that will be
macro-expanded and used as part of your wiki.  See
`setvars.sh`, `mkwiki.sh` and `template.cnf` for a list of
valid macro names.

## License

This software is released under the "GPL version 2", but not
under any later version.  Please see the file `COPYING` in
this directory for license terms.

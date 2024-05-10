# Dir-Sync: Perl library to automatically sync repositories

I have a directories with different code snippets where I play around
with different programming languages and where I collect various
pieces of research I've done. I keep adding small tests, examples,
notes, and designs continuously and have done that for a very long
time.

Since I work on a bunch of different machines over the years, I wanted
to keep these directories in sync on all machines so that I can refine
my examples and add to the pieces of research over time.

I initially used `rsync` but it is hard to keep working well to deal
with both adding, removing, and renaming files, so I have instead
opted to use Git for this.

This extension does this work by introducing a Perl extension to work
with synchronizing Git repositories on many different machines and
also provide a script that will do the work for you. It makes the
assumption that you work on one machine at a time, and that you commit
frequently, so the risk of getting a conflict is low.

I have just added these two entries to my crontab file on all machines
I work with:

```bash
@hourly mk-sync-dir $HOME/lang
@hourly mk-sync-dir $HOME/research
```

To use it, you have to:
1. Set up a Git repository in the directory you want to sync.
2. Create a remote brach on some other machine that you want to use as a central hub.

For example:

```bash
cd $HOME/lang
git init .
cat <<EOT >.gitignore 
\#*
*.bak
*.old
*.orig
*.rej
*~
.cache

.RData
.Rhistory
EOT
git add .gitignore
git commit -m'Initial commit'
git remote add origin ssh://example.org/srv/mats/lang.git
git push --set-upstream origin main
```

With this setup, `mk-sync-dir` will perform the following steps each
time it is executed:

1. Run `git add -A` to stage all files, including new ones, for
   committing. 
2. If there were no changes, just pull the remote and skip the steps
   below.
3. If there were any changes, generate a commit messaging containing
   files added, removed, and modified.
4. Get the hostname using `Net::Domain::hostname()` and directory
   using `rev-parse --show-toplevel` and use that to build the first
   line of the commit message.
5. Create a new commit with message from step 3 and 4.
6. Pull the remote with `--rebase` and `-Xours` to try to avoid
   conflicts and let "our" changes take precedence.
7. Push the kaboodle to the remote.

Note that it will ignore any files that are in the `.gitignore` and
that you can have `.gitignore` files any directory in the tree, so
this allow you to exclude files as you see fit.

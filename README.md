# Expletive


&copy; 2015 Russ Olsen

**Expletive** is a simple pair of utilities that allow you to dump a file -- presumably a binary file -- into a 
plain text format that you can edit. The trick is that as long as you follow the expletive conventions as
you edit you can turn your plain text back into a binary file. So expletive has all the charm of your typical
hex editor, *without having to learn a new editor*. Just use vim or emacs or lightTable or any other editor
of your choice.

And the name... Well typically by the time I come to having to edit a binary file I'm usually muttering some bad words.

## Installation

Add this line to your application's Gemfile:

    gem 'expletive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install expletive

## Usage

Expletive is really just two commands, `exdump` and `exundump`. The `exdump` command will take your binary file and
turn it into something you can edit with an ordinary text editor. For example, if I wanted to
edit the `ls` command, I would do something like:

```sh
$ dump < /bin/ls >ls.dump
```

What you will end up with in `ls.dump` will be plain text, albeit somewhat intimidating plain text:

    \cf\fa\ed\fe\07\00\00\01\03\00\00\80\02\00\00\00\13\00\00\00\18
    \07\00\00\85\00 \00\00\00\00\00\19\00\00\00H\00\00\00__PAGEZE
    RO\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00
    \00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00
    \00\00\00\00\00\00\00\00\00\00\00\00\00\19\00\00\00(\02\00\00
    __TEXT\00\00\00\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00

 
You can then edit the `ls.dump` file, making any changes you desire. Once you are
done you can turn your modified text back into binary with `exundump`.


```sh
$ undump < ls.dump > ls.new
```

### The Dump File Format

The format of the dumped files is as simple as my small mind can make it:

* Backslashes get converted to double backslashes, so \ becomes \\\\.

* Newlines get converted to \n - that's a backslash character followed by an "n".

* Any byte that looks like a simple, human readable single byte character is written as is.

* Otherwise the byte is written as a backslash followed by a two digit hex number. Note
that this number is zero filled: It's always \03, never \3.

* The `exdump` command will periodically insert actual newlines into the output to make
it more readable. Actual newlines are ignored by `exundump`.

That's it!

### An Example

Have you ever noticed that when you do `ls -l` in your terminal, `ls` prints
the total number of bytes at the top of the output?

```shell
~/projects/ruby/expletive: ls -l

total 304
-rw-r--r--  1 russolsen  staff    347 Jun 10 08:56 CHANGELOG.md
-rw-r--r--  1 russolsen  staff     55 Jun 10 09:20 Gemfile
-rw-r--r--  1 russolsen  staff    672 Jun 10 08:56 Gemfile.lock
-rw-r--r--  1 russolsen  staff   1067 Jun 10 08:56 LICENSE
...
```

Now imagine that for some obscure reason you wanted to make that
*total* show up as *YOOO!*. Nothing to it. First dump the contents
of the (very binary) `ls` command to some file:

```shell
exdump </bin/ls >ls.dump
```

Then edit the resulting dump file with the editor of your choice:

```shell
vi ls.dump
```

And look for the string *total*. Here is what I see when I do that:

    llu\00%lu\00printscol\00/SourceCache/file_cmds/file_cmds-242/
    ls/print.c\00dp\00total %qu\n\00%*llu \00%*qu \00%s%s %*u   \00
    %s%s %*u %-*s  \00%s%s %*u %-*s  %-*s  \00%-*s \00%3d, 0x%08x
     \00%3d, %3d \00%*s%*qu \00, \00printcol\00dp->list\00base <·

Notice the *total* on the second line. Now all you need to do is
change *total* to *YOOO!* or some other amusing string:

    llu\00%lu\00printscol\00/SourceCache/file_cmds/file_cmds-242/
    ls/print.c\00dp\00YOOO! %qu\n\00%*llu \00%*qu \00%s%s %*u   \00
    %s%s %*u %-*s  \00%s%s %*u %-*s  %-*s  \00%-*s \00%3d, 0x%08x
     \00%3d, %3d \00%*s%*qu \00, \00printcol\00dp->list\00base <·


Note that you need to make sure that your new string is the same length as the
old one (e.g. total) because executables contain counts and offsets
that you don't want to mess up.

Having made your change, you just need to convert your dump file back
to a binary. But don't overwrite your system's `ls` command!

```shell
exundump <ls.dump >ls.new
```

Make your new `ls.new` file executable:

```shell
chmod +x ls.new
```

And run your hacked binary:

```shell
./ls.new -l

YOOO! 312
-rw-r--r--  1 russolsen  staff    347 Jun 10 08:56 CHANGELOG.md
-rw-r--r--  1 russolsen  staff     55 Jun 10 09:20 Gemfile
-rw-r--r--  1 russolsen  staff    672 Jun 10 08:56 Gemfile.lock

```

One final note: With the power to edit binaries, easily and with your favorite text editor,
comes great responsibility.

## Contributors

* Russ Olsen (@russolsen)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

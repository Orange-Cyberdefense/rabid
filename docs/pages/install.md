# Installation

## Production

### Install from rubygems.org

```
$ gem install rabid
```

Gem: [rabid](https://rubygems.org/gems/rabid)

### Install from BlackArch

```
# pacman -S rabid
```

## Development

It's better to use [rbenv](https://github.com/rbenv/rbenv) to have latests version of ruby and to avoid trashing your system ruby.

### Install from rubygems.org

```
$ gem install --development rabid
```

### Build from git

Just replace `x.x.x` with the gem version you see after `gem build`.

```
$ git clone https://XXX/XXX/rabid.git rabid
$ cd rabid
$ gem install bundler
$ bundler install
$ gem build rabid.gemspec
$ gem install rabid-x.x.x.gem
```

Note: if an automatic install is needed you can get the version with `$ gem build bigipcookie.gemspec | grep Version | cut -d' ' -f4`.

### Run the library in irb without installing the gem

From local file:

```
$ irb -Ilib -rbigipcookie
```

From the installed gem:

```
$ rabid_console
```

Same for the CLI tool:

```
$ ruby -Ilib -rbigipcookie bin/rabid
```

# Installation

## Production

### Install from rubygems.org

```
$ gem install rabid
```

Gem: [rabid](https://rubygems.org/gems/rabid)

### Install from BlackArch

From the repository:

```
# pacman -S rabid
```

From git:

```
# blackman -i rabid
```

PKGBUILD: [rabid](https://github.com/BlackArch/blackarch/blob/master/packages/rabid/PKGBUILD)

### Install from ArchLinux

Manually:

```
$ git clone https://aur.archlinux.org/rabid.git
$ cd rabid
$ makepkg -sic
```

With an AUR helper ([Pacman wrappers](https://wiki.archlinux.org/index.php/AUR_helpers#Pacman_wrappers)), eg. pikaur:

```
$ pikaur -S rabid
```

AUR: [rabid](https://aur.archlinux.org/packages/rabid/)

## Development

It's better to use [rbenv](https://github.com/rbenv/rbenv) to have latests version of ruby and to avoid trashing your system ruby.

### Install from rubygems.org

```
$ gem install --development rabid
```

### Build from git

Just replace `x.x.x` with the gem version you see after `gem build`.

```
$ git clone https://github.com/Orange-Cyberdefense/rabid.git rabid
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

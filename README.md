# Git Chord - repository state manager

## Introduction

Git Chord is a git extension that adds the `chord` subcommand to git,
using which you can create, browse, manipulate, and share
snapshots of the state of a git repository.

It's that easy to take a snapshot (using the default settings):

```shell
git chord snapshot
```

Alternatively, you can create a full snapshot which includes storing the state of all supported objects,
regardless of the current configuration:

```shell
git chord snapshot --fullstore
```

And later you can restore the saved state:

```shell
git chord apply
```

Of course, you can save multiple snapshots, even on multiple tracker branches,
and you also have a freedom in applying any of them.

By default, a snapshot contains the status of all branches, annotated tags, and the HEAD.
By changing the settings, you can control, for example, which branches and tags should be saved,
and you can also require lightweight tags, dirty staging area, and dirty working tree to be saved.
Git Chord is fully customizable via git config and ad hoc comand line options,
[see below for the available options](#options).

Git Chord is particularly suitable for the following situations:

- when there is a need for sharing a constellation of the branches, across the team
- when you want to snapshot the repository state before a complex sequence of git operations
- when students are expected to submit their work as an overall repository state
- when you want to use multiple branches to deploy and rollback service configurations
- when you want to memoize specific states of the repository and browse the history of these

## Installation

The simplest way to install the git-chord command is using the netinstaller:

```shell
curl -s https://raw.githubusercontent.com/davidsusu/git-chord/main/install/netinstall-user.sh | sh
```

This will clone the source repository to the `git-chord` directory in the home directory,
and execute the bashrc based per-user intaller.

If you want to install it manually, you can use one of the installer scripts
can be found the `install` directory:

- `install-global-usrlocalbin.sh`: general global installer, requires root permission
- `install-user-bashrc-path.sh`: user-scope installer for bash environments,
   also installs bash autocompletion for the `git chord` subcommands and options
- `netinstall-user.sh`: netinstaller script, clones the repository, and install the extension

Currently no packaged version is available.

## Configuration

Configuration management in Git Chord is multi-layered.
At the lowest level are the default settings, which can be listed using the following command:

```shell
git chord config --default
```

You can override these settings in the repository's scope, for example as follows:

```shell
git chord config set stagingarea.store.enabled true
```

The overrides are stored in the standard git config store (using the `chord.` prefix).
You can list the repository scoped configuration in this way:

```shell
git chord config
```

For any command, it is possible to override the configuration ad hoc at the command line.
See below for a list of configuration options that can be overridden by command line options.
For the `snapshot` subcommand, the `--fullstore` option can be used to enable storing all supported state data of the repository,
this can be useful for full migrations and help requests.
Similarly, for the `apply` subcommand, the `--fullapply` option enables the application of all saved data.
A command with ad hoc configuration changes might look like:

```shell
git chord snapshot --fullstore --no-workingtree-store-enabled --annotatedtags-store-regex 'v.*' full
```

Git Chord supports the creation and use of profiles. Profiles override some configuration values, to do this you need to use the xxx prefix in the configuration. When a profile is applied, the value on the key after the profile prefix is overwritten. To apply a profile, use the --profile option. The --profile option can be used multiple times, in which case the named profiles are applied in order. Here is an example of using profiles:

```shell
git chord list --profile profile1 --profile profile2 --all
```

## Usage:

```
git chord <subcommand> [<arguments...>] [<options...>]
```

## Example:

```
git chord state --verbose
```

## Subcommands:

[`help`](#git-chord-help) Prints help (also works: `-h`).

[`version`](#git-chord-version) Prints version of the chord extension (also works: `-v`).

[`config`](#git-chord-config) Prints or manipulates the current chord configuration (use `--defaults` to see the defaults).

[`snapshot`](#git-chord-snapshot) Creates a snapshot of the repository state.

[`apply`](#git-chord-apply) Applies a previously saved snapshot to the repository.

[`state`](#git-chord-state) Shows the current state based on the configuration.

[`show`](#git-chord-show) Shows full data of a previously saved snapshot.

[`list`](#git-chord-list) Lists previously saved snapshots.

[`diff`](#git-chord-diff) Shows diff between a previously saved snapshot and the current state.

[`delete`](#git-chord-delete) Deletes a previously saved snapshot.

[`push`](#git-chord-push) Pushes the default chord branch (or using `--all`: all chord branches).

[`pull`](#git-chord-pull) Pulls the default chord branch (or using `--all`: all chord branches).

[`spec`](#git-chord-spec) Gets special information mainly for machine processing.

## Options:

`--trackers-prefix`: Sets the tracker branch prefix. Default: `chord/`

`--trackers-name`: Sets the tracker branch name. Default: `main`

`--trackers-remotes-default`: Sets the default remote name for tracker branches. Default: `origin`

`--[no-]trackers-remotes-allowautoassociate`: Allows/disables automatic associating of the default remote if necessary. Default: `true`

`--[no-]branches-store-enabled`: Enables/disables saving the state of tracked branches. Default: `true`

`--branches-store-regex`: Sets the regex pattern for saving tracked branches. Default: `.*`

`--[no-]branches-apply-enabled`: Enables/disables applying the saved state of tracked branches. Default: `true`

`--branches-apply-regex`: Sets the regex pattern for applying tracked branches. Default: `.*`

`--[no-]branches-apply-allowremove`: Allows/disables removing branches. Default: `true`

`--[no-]branches-apply-allowadd`: Allows/disables adding branches. Default: `true`

`--[no-]annotatedtags-store-enabled`: Enables/disables saving the state of tracked annotated tags. Default: `true`

`--annotatedtags-store-regex`: Sets the regex pattern for saving tracked annotated tags. Default: `.*`

`--[no-]annotatedtags-apply-enabled`: Enables/disables applying the saved state of tracked annotated tags. Default: `true`

`--annotatedtags-apply-regex`: Sets the regex pattern for applying tracked annotated tags. Default: `.*`

`--[no-]annotatedtags-apply-allowremove`: Allows/disables removing annotated tags. Default: `true`

`--[no-]lightweighttags-store-enabled`: Enables/disables saving the state of tracked lightweight tags. Default: `false`

`--lightweighttags-store-regex`: Sets the regex pattern for saving tracked lightweight tags. Default: `.*`

`--[no-]lightweighttags-apply-enabled`: Enables/disables applying the saved state of tracked lightweight tags. Default: `false`

`--lightweighttags-apply-regex`: Sets the regex pattern for applying tracked lightweight tags. Default: `.*`

`--[no-]lightweighttags-apply-allowremove`: Allows/disables removing lightweight tags. Default: `false`

`--[no-]head-store-enabled`: Enables/disables saving the state of the HEAD. Default: `true`

`--[no-]head-apply-enabled`: Allows/disables moving the HEAD. Default: `true`

`--[no-]head-apply-sticktocommit`: Sticks/disables to the commit, switches to detached head if necessary. Default: `false`

`--[no-]stagingarea-followhead`: Make/disables the staging area following HEAD by default. Default: `true`

`--[no-]stagingarea-store-enabled`: Enables/disables saving the state of the staging area. Default: `false`

`--[no-]stagingarea-apply-enabled`: Enables/disables applying the saved state of the staging area. Default: `false`

`--[no-]workingtree-followstagingarea`: Make/disables the working tree following the staging area by default. Default: `true`

`--[no-]workingtree-store-enabled`: Enables/disables saving the state of the working tree. Default: `false`

`--[no-]workingtree-apply-enabled`: Enables/disables applying the saved state of the working tree. Default: `false`

`--[no-]dryrun`: Enables/disables dry-run mode, no modification will be applied. Default: `false`

`--[no-]verbose`: Enables/disables verbose mode, more information will be printed. Default: `false`

`--[no-]color`: Enables/disables color mode, ANSI escapes will be used in the output. Default: `true`

`--[no-]markdown`: Enables/disables markdown mode, output will be formatted as a markdown document. Default: `false`

`--[no-]defaults`: Enables/disables default mode, the default configuration will be used and printed (forcefully). Default: `false`

`--[no-]all`: Enables/disables the operation for all related objects. Default: `false`

`--[no-]fullstore`: Forcefully/disables enables storing all the supported objects. Default: `false`

`--[no-]fullapply`: Forcefully/disables enables applying all the supported objects. Default: `false`

`--profile`: Applies configuration from a profile, can be used multiple times. Default: ``

## Exit statuses:

**0** - in case of success

**1** - in case of error

**2** - if the action was aborted due to dryrun mode

## git chord help

### Usage:

```
git chord (-h | help)
```

### Example:

```
git chord help
```

### Description:

Prints information about the available subcommands and options.

## git chord version

### Usage:

```
git chord (-v | version)
```

### Example:

```
git chord version
```

### Description:

Prints version of the git chord extension.

## git chord config

### Usage:

```
git chord config [list]
```

```
git chord config get <key>
```

```
git chord config set <key> <value>
```

### Example:

```
git chord config set annotatedtags.store.enabled false
```

### Description:

Prints information about the configuration of the git chord extension, or 
changes a configuration value for the current git repository.

### Sub-subcommands:

**list**: This is the default command. Lists all the available configuration 
keys and their values. Using the `--default` option you can see the defaults 
only, this option works out of git repositories too. Using one or more 
`--profile` argument you can apply these profiles. Using the `--all` option you 
can list the ad hoc command line options too.

**get**: Gets the value of a given configuration key. Using the `--default` 
option you can see the default value, this option works out of git repositories 
too. Using one or more `--profile` argument you can apply these profiles.

**set**: Changes the value of a given configuration key. You need to specify 
the key first, then the value. This sub-subcommand works only inside a git 
repository, and will save the value as a repository scoped git config using the 
prefix '`chord.`' in the key. Note that you can' use the `--profile` argument 
for setting a profile specific value.

**reset**: Resets the given configuration key to its default value. This 
sub-subcommand works only inside a git repository, and will remove config from 
the repository scoped git config using the prefix '`chord.`' in the key. Note 
that you can' use the `--profile` argument for resetting a profile specific 
value.

## git chord snapshot

### Usage:

```
git chord snapshot [<name>]
```

```
git chord snapshot - <branch>
```

### Example:

```
git chord snapshot my-snapshots
```

### Description:

Creates and saves a snapshot of the entire state of the repository, based on 
the configuration. If you use no parameters, the default tracker branch name 
will be used. If you use the `<name>` parameter, this branch name will be used 
with the default prefix. If you use the '`-`' argument, then the `<branch>` 
parameter will be interpreted as a full branch name. In any case, the tracker 
branch will be created if not exist.

All the dependency commits (heads of branches, tags, staging area state etc.) 
will be stored by their name and full commit hash, and all such commit hashes 
will be additional parents of the commit. The first parent is always the 
previous commit of the tracker branch, if there is no such previous commit, 
then an empty commit will be prepended. You can inspect the snapshot history by 
following the first-parent history.

## git chord apply

### Usage:

```
git chord apply [<name>] [-n]
```

```
git chord apply - <revision>
```

### Example:

```
git chord apply -3
```

### Description:

Applies the specified stored state. If you use no parameters, last state on the 
default tracker branch will be applied If you use the `<name>` parameter, this 
branch name, with the default prefix, will be used instead In these cases, if 
you use the `-<n>` parameter, where `<n>` is a non-negative whole number, you 
will refer to the nth ascendant in the first-parent history. If you use the 
'`-`' argument, then the `<revision>` parameter will be interpreted as an 
arbitrary committish It will indicate an error if the specified revision is not 
a snapshot commit.

Be careful when using the working tree, as this will cause a hard reset. In 
this case, all local changes will be saved into the stash, then erased from the 
file system.

## git chord state

### Usage:

```
git chord state
```

### Exaple:

```
git chord state
```

### Description:

Prints the current state in YAML format, based on the current configuration. 
This is the same content that will be saved using the `snapshot` command.

## git chord show

### Usage:

```
git chord show [<name>] [-<n>]
```

```
git chord show - <revision>
```

### Example:

```
git chord show -3
```

### Description:

Prints a stored state in YAML format. If you use no parameters, last commit on 
the default tracker branch will be retrieved. If you use the `<name>` 
parameter, this branch name, with the default prefix, will be retrieved. In 
these cases, if you use the `-<n>` parameter, where `<n>` is a non-negative 
whole number, you will refer to the nth ascendant in the first-parent history. 
If you use the '`-`' argument, then the `<revision>` parameter will be 
interpreted as an arbitrary committish It will indicate an error if the 
specified revision is not a snapshot commit.

## git chord list

### Usage:

```
git chord list [<name>] [-<n>]
```

```
git chord list --all
```

### Example:

```
git chord list -3
```

### Description:

Lists the previously stored snapshots. If you do not specify the `<name>` 
parameter, the default tracker branch will be used. If you specify the `<n>` 
parameter, the output will be restricted to this number of entries. If you use 
the `--all` option, all the tracker branches using the default prefix will be 
listed, even if the &lt;name&gt; parameter is specified.

The output is generated by the `git log` command using the `--oneline` format. 
If you disable colors (e.g. by using the `--no-color` option), then the 
`--color=never` argument will be appended to the `git log` command. If you use 
the `--markdown` option, the list will be rendered as simple Markdown list

## git chord diff

### Usage:

```
git chord diff [<name>] [-<n> [-<m>]]
```

```
git chord diff <name> [-<n>] <name2> [-m]
```

```
git chord diff - <revision> [<revision2>]
```

### Example:

```
git chord diff -5 -2
```

### Description:

Compares the current state or a stored state to another stored state. If you 
specify a single base revision (using neither `<name2>`, `<m>`, nor 
`<revision2>`), you will compare the current state with this specified 
revision. the current state means the data that would be printed using the 
`state` subcommand. The selection of the base revision follows the same rules 
as for the `show` command. If you specify a second revision, it will be used 
for the comparison instead of the current state. `<name2>` will be interpreted 
in the same way as `<name>`, `<m>` as `<n>`, and `<revision2>` as `<revision>`

## git chord delete

### Usage:

```
git chord delete [<name>] [-<n>]
```

### Example:

```
git chord delete -3
```

### Description:

Deletes a stored snapshot. If you use no parameters, last commit on the default 
tracker branch will be deleted. If you use the `<name>` parameter, this branch 
name, with the default prefix, will be used, and the last commit in this branch 
will be deleted. In these cases, if you use the `-<n>` parameter, where `<n>` 
is a non-negative whole number, you will refer to the nth ascendant in the 
first-parent history. If you refer to a non-snapshot commit, no deletion will 
be done, and an error message will be printed.

## git chord push

### Usage:

```
git chord push
```

### Example:

```
git chord push
```

### Description:

Pushes the default or all (using the `--all` option) tracker branches. In the 
case of branches for which a remote is already set, this remote will be used. 
The other branches will be assigned the default remote (config key: 
`trackers.remotes.default`), if the automatic association (config key: 
`trackers.remotes.allowautoassociate`) is enabled. The operation is not atomic, 
each branch will be handled separately, and in case of error, the operation 
will be continued.

## git chord pull

### Usage:

```
git chord pull
```

### Example:

```
git chord pull
```

### Description:

Fetches and rebases the default or all (using the `--all` option) tracker 
branches. In the case of branches for which a remote is already set, this 
remote will be used. The other branches will be assigned the default remote 
(config key: `trackers.remotes.default`), if the automatic association (config 
key: `trackers.remotes.allowautoassociate`) is enabled. The operation is not 
atomic, each branch will be handled separately, and in case of error, the 
operation will be continued.

## git chord spec

### Usage:

```
git chord spec <requestType>
```

### Example:

```
git chord spec commands
```

### Description:

Gets special information mainly for machine processing. The special information 
will be identified by the `<requestType>`.

### Request types:

**commands**: Lists the available commands line-by-line, followed by the 
subcommands in the same line, space-separated, if any.

**options**: Lists the available options (starting with `--`) line-by-line.


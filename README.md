# puppet-munki

This module installs and configures a [Munki client](https://github.com/munki/munki). It is a fork of [AirBnB's puppet-munki repository](https://github.com/airbnb/puppet-munki) and has been stripped down and adapted. This version installs a Munkitools package and the [CloudFront Middleware](https://github.com/AaronBurchfield/CloudFront-Middleware). It does not install a Munki configuration profile which has to be managed separately, e.g. by using your MDM of choice.

## Configuring with Hiera

``` yaml
---
classes:
 - munki

munki::munkitools_version: '3.5.0.3621'
munki::days_before_broken: 30
```

## Configuring directly in Puppet

``` puppet
class {'munki':
    munkitools_version      => '3.5.0.3621',
    days_before_broken      => 30,
}
```

For all of the configuration options, see `data/common.yaml`. Most options correlate directly with their equivalent Munki preference.

## Options that aren't Munki options

### auto_run_after_install

This will deploy a LaunchDaemon that will run `managedsoftwareupdate --auto` once before cleaning up after itself. This will allow Munki to begin it's run during your Puppet run without blocking the rest of your Puppet config.

### days_before_broken

The number of days since the last successful run after which Munki is considered 'broken' and will be reinstalled.

### munkitools_version

The version of Munki you wish to install. This is the output of `managedsoftwareupdate --version`.

### package_source

The path to the install package on your Puppet server. Defaults to `puppet:///modules/munki/munkitools-${munkitools_version}.pkg`, which means that the install package should be in the `munki` module, in `files`, named to match the version.

### Requirements

* [apple_package](https://github.com/macadmins/puppet-apple_package)
* [client_stdlib](https://github.com/macadmins/puppet-client_stdlib)
* [stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [mac_profiles_handler](https://github.com/keeleysam/puppet-mac_profiles_handler)

# Class: munki
#
# Installs and configures munki
# you must specify your own munki repo URL; please don't use http://munki and instead use a https URL.

class munki (
  String $munkitools_version,
  String $software_repo_url,
  Integer $days_before_broken,
  String $package_source,
  Boolean $auto_run_after_install,
)
{
  class { '::munki::install': }
  -> class { '::munki::service': }
  -> Class['munki']
}

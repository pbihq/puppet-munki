# Runs Munki after it has been installed

class munki::auto_run {
  $auto_run_after_install = $munki::auto_run_after_install
  $munkitools_version     = $munki::munkitools_version

  if $auto_run_after_install == true {

    if !defined(File['/usr/local/munki']){
      file {'/usr/local/munki':
        ensure => directory
      }
    }

    file {'/usr/local/munki/auto_run.sh':
      mode   => '0755',
      source => 'puppet:///modules/munki/auto_run.sh'
    }

    -> file {'/Library/LaunchDaemons/net.point-blank.daemon.munki_auto_run.plist':
      mode   => '0755',
      source => 'puppet:///modules/munki/net.point-blank.daemon.munki_auto_run.plist'
    }

    -> service {'net.point-blank.daemon.munki_auto_run':
      ensure => 'running',
      enable => true,
    }
  }
}

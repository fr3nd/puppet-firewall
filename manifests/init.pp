# == Class: firewall
#
# Creates all the necessary configuration to manage iptables via puppet
# You should include this class if you want to create rules through
# firewall::rule
#
class firewall {

    package { "iptables":
        ensure => installed,
    }

    service { "iptables":
        ensure => running,
        enable => true,
        hasrestart => true,
        status => "/sbin/service iptables status",
        require => [ Package["iptables"] , Augeas["/etc/sysconfig/iptables-config"] ],
    }

    file { "/etc/sysconfig/iptables.d/00_iptables_pre":
        ensure => present,
        content => template("firewall/iptables_pre.erb"),
        mode => 0600,
        alias => "iptables_pre",
        notify => Exec["rebuild_iptables"],
    }

    file { "/etc/sysconfig/iptables.d/99_iptables_post":
        ensure => present,
        content => template("firewall/iptables_post.erb"),
        mode => 0600,
        alias => "iptables_post",
        notify => Exec["rebuild_iptables"],
    }

    file { "/etc/sysconfig/iptables":
        ensure => present,
        notify => Exec["rebuild_iptables"],
    }

    file { "/etc/sysconfig/iptables.d":
        ensure => directory,
        purge => true,
        recurse => true,
        force => true,
        mode => 0700,
        notify => Exec["rebuild_iptables"],
    }

    exec { "rebuild_iptables":
        command => "/bin/cat /etc/sysconfig/iptables.d/* > /etc/sysconfig/iptables",
        require => [ File["iptables_pre"], File["iptables_post"] ],
        notify => Service["iptables"],
        refreshonly => true,
    }

    augeas { "/etc/sysconfig/iptables-config":
        context => "/files/etc/sysconfig/iptables-config",
        changes => "set IPTABLES_MODULES_UNLOAD no",
        notify => Service["iptables"],
        require => Package["iptables"],
    }

}

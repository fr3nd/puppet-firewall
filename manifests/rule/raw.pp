# == Define: firewall::rule::raw
#
# Create a new firewall rule in raw mode
#
# Parameters:
# * name: symbolic name of the firewall rule
# * description: rule description.
# * order: In iptables rule ordering is important. Here you can define it. Default: 50
# * comment: Comment for the rule. Will appear at the rule definition file as a comment
# * rule: parameters to be passed to iptables
#
# Example:
#
#    firewall::rule::raw { "open_everything_from_webserver":
#        comment => "Open all communications from webserver",
#        rule    => "-A INPUT --source 192.168.1.10 -j ACCEPT",
#    }
#
define firewall::rule::raw (
  $description = '',
  $order = '50',
  $comment = '',
  $rule = ''
){

  if $description != '' {
    $file_name = $description
    } else {
      $file_name = $name
    }

    file { "/etc/sysconfig/iptables.d/${order}_${file_name}":
      ensure  => present,
      mode    => '0600',
      content => template('firewall/firewall_rule.erb'),
      notify  => Exec['rebuild_iptables'],
    }

}

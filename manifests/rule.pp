# == Define: firewall::rule
#
# Creates a new firewall rule.
#
# Parameters:
# * name: symbolic name of the firewall rule
# * description: rule description.
# * order: In iptables rule ordering is important. Here you can define it. Default: 50
# * comment: Comment for the rule. Will appear at the rule definition file as a comment
# * sources: Sources for the iptables rule.
# * interfaces: Array with all the network interfaces where the rule will be applied
# * protocols: Array with all the protocols where the rule will be applied. IE: tcp, udp, icmp
# * ports: Array with all the ports where the rule will be applied
# * action: What action is defined with the rule. IE: ACCEPT, DROP,...
#
# Example:
#    firewall::rule { 'allow_mysql_from_webservers':
#        comment    => 'open mysql port to all webservers',
#        sources    => [ '192.168.1.10', '192.168.1.11' ],
#        interfaces => [ 'eth0' ],
#        protocols  => [ 'tcp' ],
#        ports      => [ "3306" ],
#    }
#
define firewall::rule (
    $ensure = "present",
    $description = "",
    $order = "50",
    $comment = '',
    $sources = '',
    $interfaces = [ 'eth0' ],
    $protocols = [ 'tcp' ],
    $ports = '',
    $action = 'ACCEPT'
) {

    if $description != "" {
        $file_name = $description
    } else {
        $file_name = $name
    }

    file { "/etc/sysconfig/iptables.d/${order}_${file_name}":
        ensure => $ensure,
        mode => 0600,
        content => template("firewall/firewall_rule.erb"),
        notify => Exec["rebuild_iptables"],
    }

}

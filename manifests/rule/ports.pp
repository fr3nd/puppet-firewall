# == Define firewall::rule::ports
#
# Helper definition to open firewall using ports instead of ip address as a
# resource name.
#
# Format of the $name parameter:
#  port/protocol:source_ip:destination_host_name
#
# the destination_host_name is used only for clarity and it's not used in the
# iptables rule at all
#
# Example:
#
# firewall::rule::ports { "3306/tcp:192.168.1.1:hostname":
#    interfaces => "eth0",
# }
#
define firewall::rule::ports (
  $ensure = "present",
  $order = "50",
  $interfaces = "eth0",
  $action = "ACCEPT",
  $host_name = ""
) {

  $port = inline_template("<%= name.split('/')[0] %>")
  $protocol = inline_template("<%= name.split('/')[1].split(':')[0] %>")
  $sources_string = inline_template("<%= name.split(':')[1] %>")
  $host = inline_template("<%= name.split(':')[2] %>")
  $sources = split($sources_string, ",")

  firewall::rule { "allow_${port}_${protocol}_from_${sources_string}_to_${host}":
    description => "allow_${port}_${protocol}_from_${host_name}_${sources_string}_to_${host}",
    comment     => "allow ${port}/${protocol} from ${host_name} (${sources_string}) to ${host}",
    order       => $order,
    sources     => $sources,
    interfaces  => $interfaces,
    protocols   => $protocol,
    ports       => $port,
    action      => $action,
  }
}

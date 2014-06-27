# puppet firewall

Basic firewall module to use with iptables

To create a new firewall rule, use the firewall-rule definition:

```
include firewall

firewall::rule { "allow_from_webserver":
  order     => 20,
  comment   => "Allow ping and snmp from webserver",
  sources   => [ "192.168.1.100" ],
  interface => [ "eth0", "eth1" ],
  protocols => [ "tcp", "udp", "icmp" ],
  ports     => [ "161" ],
  action    => "ACCEPT",
}
```

this rule will allow snmp(tcp and udp) and ping from 192.168.1.100

Allowed parameters:
- **order** - The order of preference for this rule from 00 to 99. By default 50
- **comment** - Description of what the rule does. Not mandatory but strongly recommended
- **sources** - Sources specification for the rule. It can be either a network name, a hostname a network IP address (with /mask), or a plain IP address. Use 0.0.0.0/0 for "ALL". It can contain one or multiple elements into an array.
- **interfaces** - Interface or interface where the rule will be applied to. It can contain one or multiple elements into an array.
- **protocols** - Protocol or protocols where to apply the rule. It can be "tcp", "udp" or "icmp". It can contain one or multiple elements into an array.
- **ports** - Ports where to apply the rule. It can contain one or multiple elements into an array.
- **action** - What to do. If ommited will use ACCEPT as a default. It can also contain DROP or REJECT.


## Why?

dnsmasq is a feature-full yet lightweight DNS tool predominatly used for local dnscache'ing and tooling. 

For elastic cloud environments, tooling for scale up / scale down functionality may be prohibitively complex, and dnsmasq can be used to simplify discovery and configuration.

In the case of hadoop, which has a heavy handed dependancy on forward <-> reverse DNS, the `synth-domain` configuration can be used to simplify the problems of dynamically resizing a hadoop cluster without the need to re-provision.

* Requires dnsmasq version 2.68 for `synth-domain`

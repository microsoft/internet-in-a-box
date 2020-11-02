# iBox: Internet in a Box
*Enabling data-informed network simulation*

## About iBox

The **iBox** (Internet in a Box) project is an ongoing effort on enabling data-informed network simulation. Currently, we use data in the form of per-packet traces gathered at senders and receivers of networked applications to learn network parameters and configure a network simulator accordingly.

The purpose of this repo is to make these network configurations available to the research community.

## About generated network profiles
### Data source
We currently use the packet traces openly available from the [Pantheon project](https://pantheon.stanford.edu/) at Stanford [[1]](#1)

### Format of the network profiles
The JSON files corresponding to each network profile mainly contain the following: 
1. **Basic network parameters**
	1. **`bottleneck_bandwidth`** (in kbps)
	2. **`buffer_size_bytes`** (in bytes)
	3. **`buffer_size_packets`** (in MTU sized packets)
	4. **`propagation_delay`** (in milliseconds)
2.  **Cross traffic estimate**
	1. **`cross_traffic_pattern`**:  a 30s long timeseries with each entry in kbps
3. **Metadata**
	1. **`measurement_node`**: endpoint A of the flow
	2. **`peer_cloud_server`**: endpoint B of the flow
	3. **`data_flow_direction`**: direction of the data flow
	4. **`link_type`**: type of network link in the experiment
	5. **`data_source_url`**: static url to the source of the data used for generating this network profile

### Notes
1. The **`cross_traffic_pattern`** is a timeseries *ct* and it is used in the simulation\emulation experiment by configuring a UDP sender to set its sending rate to *ct*<sub>*i*</sub> kbps at time *i*.
2. The network parameters are learned only for one direction (as indicated by the **`link_type`**) while the reverse direction's parameters (for example, the parameters of the downlink in this [network profile](https://github.com/microsoft/internet-in-a-box/blob/main/network-profiles/colombia/cellular/network-profile-1.json)) is populated using default values used for the experiments such that the packets in this direction are not delayed/dropped. 

## Quick Start
Todo: add details regarding sample scripts

## Questions?
If you have any questions, please feel free to [open an issue](https://github.com/microsoft/internet-in-a-box/issues/new) and describe your query

## References
<a id="1">[1]</a> Francis Y. Yan, Jestin Ma, Greg Hill, Deepti Raghavan, Riad S. Wahby, Philip Levis, and Keith Winstein, Pantheon: the training ground for Internet congestion-control research in USENIX ATC 18
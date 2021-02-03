# iBox: Internet in a Box
*Data-informed Network Simulation Profiles*

## About iBox

The **iBox** (Internet in a Box) project is an ongoing effort at [Microsoft Research India](https://www.microsoft.com/en-us/research/lab/microsoft-research-india/) on enabling data-informed network simulation. Currently, we use data in the form of per-packet traces gathered at senders and receivers of networked applications to learn network parameters and configure a network simulator accordingly. 

You can find more details of the work on the [project website](http://aka.ms/ibox) and in our [HotNets'20 paper](https://www.microsoft.com/en-us/research/uploads/prod/2020/09/iBox-HotNets2020.pdf) [[1]](#1).

The purpose of this repo is to make **iBox**  network configurations available to the research community. Specifically, we focus here on **iBoxNet**, which is a network model based variant of **iBox**.

## About generated **iBoxNet** network profiles
### Data source
We currently use the packet traces available from the [Pantheon project](https://pantheon.stanford.edu/) [[2]](#2) at Stanford to generate the **iBoxNet** network profiles.

### Format of the **iBoxNet** network profiles
The JSON files corresponding to each **iBoxNet** network profile mainly contain the following: 
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
	5. **`data_source_url`**: static url to the source of the data used for generating this **iBoxNet** network profile

### Notes
1. The **`cross_traffic_pattern`** is a timeseries *ct* and it is used in the simulation\emulation experiment by configuring a UDP sender to set its sending rate to *ct*<sub>*i*</sub> kbps at time *i*.
2. The network parameters corresponding to the Pantheon traces are learned only for one direction (as indicated by the **`link_type`** for which the data is collected) while the reverse direction's parameters (for example, the parameters of the downlink in this [network profile](https://github.com/microsoft/internet-in-a-box/blob/main/network-profiles/colombia/cellular/network-profile-1.json)) are populated using default values (not learned from data). 

## Quick Start
To get started on running ns-2 simulations using the profiles, some sample ns-2 scripts have been provided in the src/sample-code directory. 

Please install ns-2, tcl, and tcllib and run the following command:

```bash
ns src/sample-code/single-link-with-cross-traffic.tcl arg1 arg2
```
where `arg1` is the path to the **iBoxNet** network profile and `arg2` is the directory you want to save your experiment trace file in.

The sample script sets up the network topology corresponding to the **iBoxNet** network profile in addition to configuring the cross traffic sender to send traffic into the network appropriately. Further, the script runs a TCP Cubic file transfer for 30s on this network and saves the trace file corresponding to this simulation.

## Questions?
If you have any questions, please feel free to [open an issue](https://github.com/microsoft/internet-in-a-box/issues/new) and describe your query.

## Citations

If you'd like to cite our paper, please use this doi: [10.1145/3422604.3425935](https://doi.org/10.1145/3422604.3425935) and if you'd like to cite our network profiles, please use this [GitHub link](https://github.com/microsoft/internet-in-a-box).


## References
<a id="1">[1]</a> S. Ashok, S. S. Duvvuri, N. Natarajan, V. N. Padmanabhan, S. Sellamanickam, and J. Gehrke. "iBox: Internet in a Box". In Proceedings of the 19th ACM Workshop on Hot Topics in Networks, HotNets ’20, page 23–29, New York, NY, USA, 2020. Association for Computing Machinery.  
<a id="2">[2]</a> F. Y. Yan, J. Ma, G. D. Hill, D. Raghavan, R. S. Wahby, P. Levis, and K. Winstein.   Pantheon: the training ground for internet congestion-control research. In 2018 USENIX Annual Technical Conference (USENIX ATC 18), pages 731–743, 2018

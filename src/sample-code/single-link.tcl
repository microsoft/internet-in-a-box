package require json

# Create a simulator object
set ns [new Simulator]

# Define a 'finish' procedure
proc finish {} {
    global ns tf
    $ns flush-trace
    # Close the packet trace file
    close $tf
    exit 0
}

# Load the JSON profile as a dict in tcl
set networkProfilePath [lindex $argv 0]
set loadedFile [open $networkProfilePath r]
set profileString [read $loadedFile]
set profile [json::json2dict $profileString]
close $loadedFile

# Load network parameters for uplink and downlink
set params [dict get $profile config]

set uplinkParams [dict get $params uplink]
set bottleneckBandwidthUplink [dict get $uplinkParams bottleneck_bandwidth]kbps
set bufferSizeInPacketsUplink [dict get $uplinkParams buffer_size_packets]
set propagationDelayUplink [dict get $uplinkParams propagation_delay]ms

set downlinkParams [dict get $params downlink]
set bottleneckBandwidthDownlink [dict get $downlinkParams bottleneck_bandwidth]kbps
set bufferSizeInPacketsDownlink [dict get $downlinkParams buffer_size_packets]
set propagationDelayDownlink [dict get $downlinkParams propagation_delay]ms

# Create sender and receiver nodes
set n0 [$ns node]
set n1 [$ns node]

# Setting trace file for packet level trace
set traceFile [lindex $argv 1]experiment.tr
set tf [open $traceFile w]
$ns trace-all $tf

# Create links between the nodes
$ns simplex-link $n0 $n1 $bottleneckBandwidthUplink $propagationDelayUplink DropTail
$ns simplex-link $n1 $n0 $bottleneckBandwidthDownlink $propagationDelayDownlink DropTail

puts "Uplink: Bottleneck bandwidth set to $bottleneckBandwidthUplink"
puts "Uplink: Buffer size set to $bufferSizeInPacketsUplink packets"
puts "Uplink: Propagation delay set to $propagationDelayUplink"
puts "Uplink: TCP Cubic sender set up to send flow traffic from s (sender) to r (receiver)"

# Set queue sizes
$ns queue-limit $n0 $n1 $bufferSizeInPacketsUplink
$ns queue-limit $n1 $n0 $bufferSizeInPacketsDownlink

# Setup TCP connection 1
set tcp1 [new Agent/TCP/Linux]
$tcp1 set packetSize_ 1500
$tcp1 set window_ 65536
$tcp1 set class_ 2
$ns at 0 "$tcp1 select_ca cubic"
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink/Sack1/DelAck]
$ns attach-agent $n1 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1

# Setup an FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

# Tcp1 start stop
$ns at 00.0 "$ftp1 start"
$ns at 30.0 "$ftp1 stop"

# Detach tcp and sink agents
$ns at 35.0 "$ns detach-agent $n0 $tcp1 ; $ns detach-agent $n1 $sink1"

# Call the finish procedure after 40 seconds of simulation time
$ns at 40.0 "finish"

#Run the simulation
$ns run
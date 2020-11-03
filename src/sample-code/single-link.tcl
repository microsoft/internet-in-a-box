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

# Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]

# Setting tunable parameters for experiment
set linkSpeed [lindex $argv 0]Kb
set delay [lindex $argv 1]ms
set bufferSize [lindex $argv 2]
set expNum [lindex $argv 3]

puts $linkSpeed
puts $delay
puts $bufferSize
puts $expNum

# Setting trace file for packet level trace
set base_path "/directory/to/save/the/packet/trace"
set fileName "exp-$expNum.tr"
set tf_path $base_path$fileName
set tf [open $tf_path w]
$ns trace-all $tf

# Create links between the nodes
$ns duplex-link $n0 $n1 $linkSpeed $delay DropTail
# $ns simplex-link $n0 $n1 $linkSpeed $delay DropTail
# $ns simplex-link $n1 $n0 100Mb 0ms DropTail

# Set queue size of link (n0-n1)
$ns queue-limit $n0 $n1 $bufferSize

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

# Schedule events for the FTP agents

# Tcp1 start stop
$ns at 00.0 "$ftp1 start"
$ns at 30.0 "$ftp1 stop"

# Detach tcp and sink agents
$ns at 35.0 "$ns detach-agent $n0 $tcp1 ; $ns detach-agent $n1 $sink1"

# Call the finish procedure after 40 seconds of simulation time
$ns at 40.0 "finish"

#Run the simulation
$ns run

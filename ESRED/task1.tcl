#command line arguments
set node_count      [lindex $argv 0]
set flow_count      [lindex $argv 1]
set packet_rate     [lindex $argv 2]
set co_tx_range     [lindex $argv 3]
set flg             [lindex $argv 4]
# simulator
set ns [new Simulator]

#set additional params
set area_size           500
set cbr_interval		[expr 1.0/$packet_rate]

# ================================================================
# RED Params
Queue/RED set thresh_ 10
Queue/RED set maxthresh_ 30
Queue/RED set q_weight_ 0.002
Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ false
Queue/RED set gentle_ false
Queue/RED set mean_pktsize_ 84
# Queue/RED set max_p_ 0.02
Queue/RED set flag  $flg
# ================================================================

# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel           ;# channel type
set val(prop)         Propagation/TwoRayGround          ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna               ;# Antenna type
set val(ll)           LL                                ;# Link layer type
set val(ifq)          Queue/RED                         ; # Interface queue type
set val(ifqlen)       50                                ;# max packet in ifq
set val(netif)        Phy/WirelessPhy                   ;# network interface type
set val(mac)          Mac/802_11                        ;# MAC type
set val(rp)           DSDV                              ;# ad-hoc routing protocol 
set val(nn)           $node_count                       ;# number of mobilenodes
set val(nf)           $flow_count                       ;# number of flows
set val(as)           $area_size                        ;# area size
# =======================================================================

# ==================================
# Power options

set val(energymodel_11)         EnergyModel		;
set val(initialenergy_11)       1000            ;# Initial energy in Joules

set val(idlepower_11)			869.4e-3		;#LEAP (802.11g)
set val(rxpower_11)				1560.6e-3		;#LEAP (802.11g)
set val(txpower_11)				1679.4e-3		;#LEAP (802.11g)
set val(sleeppower_11)			37.8e-3			;#LEAP (802.11g)
# ==================================

# ==================================
# Setting coverage area
set nowValue_Pt [Phy/WirelessPhy set Pt_]                  
set newValue_Pt [expr $co_tx_range * $co_tx_range * $nowValue_Pt]    ;#To change coverage area, multiply with coefficient^2 X Pt_
Phy/WirelessPhy set Pt_ $newValue_Pt;	
# ==================================

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all-wireless $nam_file $area_size $area_size

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid $area_size $area_size ;# area


# general operation director for mobilenodes
create-god $val(nn)


$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF \
                -energyModel $val(energymodel_11) \
                -idlePower $val(idlepower_11) \
                -rxPower $val(rxpower_11) \
                -txPower $val(txpower_11) \
                -sleepPower $val(sleeppower_11) \
                -initialEnergy $val(initialenergy_11)


# create nodes
for {set i 0} {$i < $val(nn) } {incr i} {
    set node($i) [$ns node]
    $node($i) random-motion 0       ;# disable random motion
    
    $node($i) set X_ [expr int($val(as) * rand())]
    $node($i) set Y_ [expr int($val(as) * rand())]
    $node($i) set Z_ 0

    $ns initial_node_pos $node($i) 20
} 

# producing flows
for {set i 0} {$i < $val(nf)} {incr i} {
    set src  [expr {int(rand()*$val(nn))}]
    set sink [expr {int(rand()*$val(nn))}]

    if [expr $src == $sink] {
        incr i -1
        continue
    }
    
    # Traffic config
    # create agent
    set udp [new Agent/UDP]
    set null [new Agent/Null]
   

    # attach to nodes
    $ns attach-agent $node($src) $udp
    $ns attach-agent $node($sink) $null
    # connect agents
    $ns connect $udp $null
    $udp set fid_ $i

    # Traffic generator
    set cbr [new Application/Traffic/CBR]
    $cbr set type_          CBR
    $cbr set packet_size_   64
    $cbr set rate_          11Mb
    $cbr set interval_      $cbr_interval
    $cbr set random_        false
    # attach to agent
    $cbr attach-agent $udp
    
    # start traffic generation
    $ns at 0.2 "$cbr start"
    
}


# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 5.0 "$node($i) reset"
}

# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    puts "Simulation ending"
    $ns halt
}

$ns at 5.0001 "finish"
$ns at 5.0002 "halt_simulation"


# Run simulation
puts "Simulation starting"
$ns run

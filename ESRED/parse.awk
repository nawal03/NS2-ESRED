BEGIN {
    received_packets = 0;
    sent_packets = 0;
    dropped_packets = 0;
    total_delay = 0;
    received_bytes = 0;
    
    start_time = 1000000;
    end_time = 0;

    # constants
    header_bytes = 8;

    total_energy_consumption = 0;

    for (i=0; i<100; i++) {
		per_node_drop[i] = 0;		
	}
    for (i=0; i<100; i++) {
		per_node_packet[i] = 0;		
	}

    min_drop_ratio = 1;
    max_drop_ratio = 0;

}

{
    event = $1;
    time_sec = $2;
    node = $3;
    layer = $4;
    packet_id = $6;
    packet_type = $7;
    packet_bytes = $8;

    energy = $13;			
    total_energy = $14;
	idle_energy_consumption = $16;	
    sleep_energy_consumption = $18; 
	transmit_energy_consumption = $20;	
    receive_energy_consumption = $22;


    sub(/^_*/, "", node);
    sub(/_*$/, "", node);

    
    if(end_time < time_sec){
        end_time = time_sec;
    }

    if(start_time > time_sec && time_sec != "-t") {
        start_time = time_sec;
    }

    if (energy == "[energy") {
		total_energy_consumption += (idle_energy_consumption + sleep_energy_consumption + transmit_energy_consumption + receive_energy_consumption);
	}


    if (layer == "AGT" && packet_type == "cbr") {
        if(event == "s") {
            sent_time[packet_id] = time_sec;
            sent_packets += 1;
            per_node_packet[node]++;
        }

        else if(event == "r") {
            delay = time_sec - sent_time[packet_id];
            total_delay += delay;
            bytes = (packet_bytes - header_bytes);
            received_bytes += bytes;
            received_packets += 1;
        }
        
    }
    if (packet_type == "cbr" && event == "D") {
        dropped_packets += 1;
        per_node_drop[node]++;
    }
    
}


END {
    simulation_time = end_time - start_time;
    for(i=0;i<100;i++){
        if(per_node_packet[i]!=0){
            per_node_drop[i]/=per_node_packet[i];
            if(min_drop_ratio>per_node_drop[i]) min_drop_ratio = per_node_drop[i];
            if(max_drop_ratio<per_node_drop[i]) max_drop_ratio = per_node_drop[i];
        }
    }

    # print "Sent Packets: ", sent_packets;
    # print "Dropped Packets: ", dropped_packets;
    # print "Received Packets: ", received_packets;

    # print "-------------------------------------------------------------";
    # print "Throughput: ", (received_bytes * 8) / simulation_time, "bits/sec";
    # print "Average Delay: ", (total_delay / received_packets), "seconds";
    # print "Delivery ratio: ", (received_packets / sent_packets);
    # print "Drop ratio: ", (dropped_packets / sent_packets);
    # printf("Energy Consumption: %f\n", total_energy_consumption);
    # printf("Difference in drop ratio: %f\n", max_drop_ratio - min_drop_ratio);

    print (received_bytes * 8) / simulation_time / 1000 >> "throughput.txt";
    print (total_delay / received_packets) >> "avg-delay.txt";
    print (received_packets / sent_packets) * 100 >> "delivery-ratio.txt";
    print (dropped_packets / sent_packets) * 100 >> "drop-ratio.txt";
    printf("%f\n", total_energy_consumption / 1000 ) >>"energy-consumption.txt";
    printf("%f\n", (max_drop_ratio - min_drop_ratio) * 100 ) >> "diff-drop-ratio.txt";
}

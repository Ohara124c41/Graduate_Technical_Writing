package org.eclipse.leshan.client.demo;

import java.awt.Image;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.swing.ImageIcon;



import org.eclipse.leshan.client.resource.BaseInstanceEnabler;
import org.eclipse.leshan.client.servers.ServerIdentity;
import org.eclipse.leshan.core.model.ObjectModel;
import org.eclipse.leshan.core.response.ReadResponse;
import org.eclipse.leshan.core.util.NamedThreadFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class VehicleCounter extends BaseInstanceEnabler{

	private static final Logger LOG = LoggerFactory.getLogger(VehicleCounter.class);
	
	private static final List<Integer> supportedResources = Arrays.asList(2,3, 4);
	MyLocation location;
	
	private String direction = "entry";
	private  String lot = "parking lot name";
	private int counter	= 0;
	private String lastplate="";
	private double location_y = 10;//location.getLatitude();
	private double location_x = 10 ;//location.getLongitude();
	private final ScheduledExecutorService scheduler;
	
	
	public VehicleCounter() {
        this.scheduler = Executors.newSingleThreadScheduledExecutor(new NamedThreadFactory("plate recognizer"));
        scheduler.scheduleAtFixedRate(new Runnable() {

            @Override
            public void run() {
                try {
					scanPlate();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
            }

        }, 2, 2, TimeUnit.SECONDS);
    }
	
	
	@Override
    public ReadResponse read(ServerIdentity identity, int resourceid) {
        LOG.info("Read on vihecle counter  /{}/{}/{}", getModel().id, getId(), resourceid);
        switch (resourceid) {
        
        case 2:
            return ReadResponse.success(resourceid, getDirection());
        case 3:
            return ReadResponse.success(resourceid, getCounter());
        case 4:
            return ReadResponse.success(resourceid, getLastPlate());
            
        default:
            return super.read(identity, resourceid);
        }
    }

	
	
	private String getDirection() {
		return direction;
	}


	private String getLastPlate() {
		return lastplate;
	}


	private int getCounter() {
		return counter;
	}


	private void scanPlate() throws IOException {
		Process process = Runtime.getRuntime().exec("python Test1.py ");
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        String newplate = null;
        //System.out.println(reader);
        while ((line = reader.readLine()) != null) {
            //System.out.println(line);
        	newplate = line;
        }
        //System.out.println("plateNumber:" + newplate);
		if (newplate!=null && !(newplate.equals(lastplate))) {
			counter +=1 ;
			lastplate = newplate;
			
			fireResourcesChange(3,4);
			System.out.println("plateNumber:" + newplate);
			System.out.println("Counter value:" +(counter));
		}
		reader.close();
		
		
	}
	
	@Override
    public List<Integer> getAvailableResourceIds(ObjectModel model) {
        return supportedResources;
    }
	
}

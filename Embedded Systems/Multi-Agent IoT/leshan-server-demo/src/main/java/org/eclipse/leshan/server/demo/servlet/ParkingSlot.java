package org.eclipse.leshan.server.demo.servlet;

public class ParkingSlot {
	public String status;
	public int x, y;
	public String ID;
	public String licensePlate;
	public float billingRate;	
	
	public ParkingSlot(String status, int x, int y, String iD, String licensePlate, float billingRate) {
		super();
		this.status = status;
		this.x = x;
		this.y = y;
		ID = iD;
		this.licensePlate = licensePlate;
		this.billingRate = billingRate;
	}

	@Override
	public String toString() {
		return "{\"ID\":\""+ID+"\", "
				+ "\"status\":\""+status+"\", "
				+ "\"location\": ["+x+", "+y+"], "
				+ "\"billingRate\":"+billingRate+", "
				+ "\"licensePlate\":\""+licensePlate+"\"}";
	}
}

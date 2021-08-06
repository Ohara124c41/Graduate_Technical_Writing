package org.eclipse.leshan.server.demo.servlet;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.eclipse.leshan.core.attributes.AttributeSet;
import org.eclipse.leshan.core.model.LwM2mModel;
import org.eclipse.leshan.core.model.ObjectLoader;
import org.eclipse.leshan.core.model.ResourceModel;
import org.eclipse.leshan.core.model.ResourceModel.Type;
import org.eclipse.leshan.core.model.StaticModel;
import org.eclipse.leshan.core.node.LwM2mNode;
import org.eclipse.leshan.core.node.LwM2mResource;
import org.eclipse.leshan.core.node.LwM2mObjectInstance;
import org.eclipse.leshan.core.node.LwM2mPath;
import org.eclipse.leshan.core.node.LwM2mSingleResource;
import org.eclipse.leshan.core.node.codec.CodecException;
import org.eclipse.leshan.core.request.ContentFormat;
import org.eclipse.leshan.core.request.CreateRequest;
import org.eclipse.leshan.core.request.DeleteRequest;
import org.eclipse.leshan.core.request.DiscoverRequest;
import org.eclipse.leshan.core.request.ExecuteRequest;
import org.eclipse.leshan.core.request.ObserveRequest;
import org.eclipse.leshan.core.request.ReadRequest;
import org.eclipse.leshan.core.request.WriteAttributesRequest;
import org.eclipse.leshan.core.request.WriteRequest;
import org.eclipse.leshan.core.request.WriteRequest.Mode;
import org.eclipse.leshan.core.request.exception.ClientSleepingException;
import org.eclipse.leshan.core.request.exception.InvalidRequestException;
import org.eclipse.leshan.core.request.exception.InvalidResponseException;
import org.eclipse.leshan.core.request.exception.RequestCanceledException;
import org.eclipse.leshan.core.request.exception.RequestRejectedException;
import org.eclipse.leshan.core.response.CreateResponse;
import org.eclipse.leshan.core.response.DeleteResponse;
import org.eclipse.leshan.core.response.DiscoverResponse;
import org.eclipse.leshan.core.response.ErrorCallback;
import org.eclipse.leshan.core.response.ExecuteResponse;
import org.eclipse.leshan.core.response.LwM2mResponse;
import org.eclipse.leshan.core.response.ObserveResponse;
import org.eclipse.leshan.core.response.ReadResponse;
import org.eclipse.leshan.core.response.ResponseCallback;
import org.eclipse.leshan.core.response.WriteAttributesResponse;
import org.eclipse.leshan.core.response.WriteResponse;
import org.eclipse.leshan.server.californium.LeshanServer;
import org.eclipse.leshan.server.demo.servlet.json.LwM2mNodeDeserializer;
import org.eclipse.leshan.server.demo.servlet.json.LwM2mNodeSerializer;
import org.eclipse.leshan.server.demo.servlet.json.RegistrationSerializer;
import org.eclipse.leshan.server.demo.servlet.json.ResponseSerializer;
import org.eclipse.leshan.server.demo.utils.MagicLwM2mValueConverter;
import org.eclipse.leshan.server.registration.Registration;

import org.eclipse.californium.core.network.Endpoint;
import org.eclipse.jetty.servlets.EventSource;
import org.eclipse.jetty.servlets.EventSourceServlet;
import org.eclipse.leshan.core.node.LwM2mNode;
import org.eclipse.leshan.core.observation.Observation;
import org.eclipse.leshan.core.response.ObserveResponse;
import org.eclipse.leshan.server.californium.LeshanServer;
import org.eclipse.leshan.server.demo.servlet.json.LwM2mNodeSerializer;
import org.eclipse.leshan.server.demo.servlet.json.RegistrationSerializer;
import org.eclipse.leshan.server.demo.servlet.log.CoapMessage;
import org.eclipse.leshan.server.demo.servlet.log.CoapMessageListener;
import org.eclipse.leshan.server.demo.servlet.log.CoapMessageTracer;
import org.eclipse.leshan.server.observation.ObservationListener;
import org.eclipse.leshan.server.queue.PresenceListener;
import org.eclipse.leshan.server.registration.RegistrationListener;
import org.eclipse.leshan.server.registration.RegistrationUpdate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;

import org.eclipse.leshan.server.demo.servlet.ParkingSlot;
import org.eclipse.leshan.server.demo.servlet.RunPythonCode;

public class ParkingLotServlet extends HttpServlet {

	LeshanServer server;
	Map<String, ParkingSlot> slots = new HashMap<String, ParkingSlot>();
	Map<String, String> directions = new HashMap<String, String>();
	Map<String, Integer> counts = new HashMap<String, Integer>();
	private static final Logger LOG = LoggerFactory.getLogger(ParkingLotServlet.class);

	// endPoints: reserve , getInfo
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		resp.addHeader("Access-Control-Allow-Origin", "*");

		try {
			if (req.getPathInfo() == null) {
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
				return;
			}

			String[] path = StringUtils.split(req.getPathInfo(), '/');
			if (path.length < 1) {
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
				return;
			}
			String endPoint = path[0];

			// /endPoint : get client
			if (endPoint.equals("reserve")) {
				// forward reservation
				// /reserve/<parking spot id>/<license plate>

				String clientEndpoint = path[1];
				String licensePlate = path[2];

				Registration registration = server.getRegistrationService().getByEndpoint(clientEndpoint);

				if (registration != null) {

					WriteRequest statusWriteRequest = new WriteRequest(32700, 0, 1, "reserved");
					WriteRequest licensePlateWriteRequest = new WriteRequest(32700, 0, 2, licensePlate);
					//WriteRequest displayRequest = new WriteRequest(3341, 0, 5527, "orange");

					server.send(registration, statusWriteRequest);
					server.send(registration, licensePlateWriteRequest);
					//server.send(registration, displayRequest);

					resp.setStatus(HttpServletResponse.SC_OK);
				} else {
					resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
					resp.getWriter().format("no registered client with id '%s'", clientEndpoint).flush();
				}
				return;
			}

			if (endPoint.equals("info")) {
				// handle getInfo

				int numVehicles = 0;

				for (String counterID : directions.keySet()) {
					int inOrOut = directions.get(counterID).equals("entry") ? 1 : -1;
					numVehicles += inOrOut * counts.get(counterID);
				}

				String output = "{\"numVehicles\":" + numVehicles + ", \"slots\":[";
				for (String slotId : slots.keySet()) {
					ParkingSlot slot = slots.get(slotId);
					output += slot.toString();
					output += ",";
				}
				if (!slots.isEmpty()) {
					output = output.substring(0, output.length() - 1);
				}
				output += "]}";
				resp.setContentType("application/json");
				resp.getOutputStream().write(output.getBytes());
				resp.setStatus(HttpServletResponse.SC_OK);
//			    java.util.Random r = new java.util.Random();
//			    RunPythonCode.pipe(r.nextInt(8)+ "," + r.nextInt(8) +",reserved"); //TODO: change it to slot values
//			    RunPythonCode.pipe(r.nextInt(8)+ "," + r.nextInt(8) +",free"); //TODO: change it to slot values
//			    RunPythonCode.pipe(r.nextInt(8)+ "," + r.nextInt(8) +",occupied"); //TODO: change it to slot values
				return;
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

	private final ObservationListener observationListener = new ObservationListener() {

		@Override
		public void cancelled(Observation observation) {
		}

		@Override
		public void onResponse(Observation observation, Registration registration, ObserveResponse response) {
			/*
			 * if (LOG.isDebugEnabled()) {
			 * LOG.debug("Received notification from [{}] containing value [{}]",
			 * observation.getPath(), response.getContent().toString()); }
			 */

			if (registration != null) {
				// String data = new
				// StringBuilder("{\"ep\":\"").append(registration.getEndpoint()).append("\",\"res\":\"")
				// .append(observation.getPath().toString()).append("\",\"val\":")
				// .append(gson.toJson(response.getContent())).append("}").toString();
				//int observationObjectId = Integer.valueOf(observation.getPath().toString().split("/")[1]);
				String observationObjectId = observation.getPath().toString();
				LOG.warn("observationObjectId:" + observationObjectId);
				if (observationObjectId.equals("/32700/0")) { // slot
					ParkingSlot oldSlot = slots.get(registration.getEndpoint());
					try {
						ParkingSlot newSlot = new ParkingSlot(
								(String) (((LwM2mObjectInstance) response.getContent()).getResource(1).getValue()), oldSlot.x,
								oldSlot.y, registration.getEndpoint(),
								(String) (((LwM2mObjectInstance) response.getContent()).getResource(2).getValue()),
								((Double) (((LwM2mObjectInstance) response.getContent()).getResource(3).getValue())).floatValue());
						slots.put(registration.getEndpoint(), newSlot);
						RunPythonCode.pipe(newSlot.x + "," + newSlot.y + "," + newSlot.status); // TODO: change it to slot

						LOG.warn("observer: " + newSlot); // values
						
					} catch (Exception ex) {
						LOG.warn("oobs observe slot", ex);
					}
				}
				if (observationObjectId.equals("/32701/0")) { // counter
					try {
					directions.put(registration.getEndpoint(),
							(String) (((LwM2mObjectInstance) response.getContent()).getResource(2).getValue()));
					counts.put(registration.getEndpoint(),
							(Integer) (((LwM2mObjectInstance) response.getContent()).getResource(3).getValue()));
					} catch (Exception ex) {
						LOG.warn("ooobss observe counter", ex);
					}
				}

			}

		}

		@Override
		public void onError(Observation observation, Registration registration, Exception error) {
			/*
			 * if (LOG.isWarnEnabled()) {
			 * LOG.warn(String.format("Unable to handle notification of [%s:%s]",
			 * observation.getRegistrationId(), observation.getPath()), error); }
			 */
		}

		@Override
		public void newObservation(Observation observation, Registration registration) {
		}
	};

	private final RegistrationListener registrationListener = new RegistrationListener() {

		@Override
		public void registered(Registration registration, Registration previousReg,
				Collection<Observation> previousObsersations) {
			
			try {
				ReadRequest locationRead = new ReadRequest(6,0);
				final Registration reg = registration;
				server.send(reg, locationRead, new ResponseCallback<ReadResponse>() {
					
					public void onResponse(ReadResponse locationResponse) {
						
						LOG.warn("registration response before location");
						
						final int location_x = (int) Math.round((Double) ((LwM2mObjectInstance) locationResponse.getContent()).getResource(0).getValue());
						final int location_y = (int) Math.round((Double) ((LwM2mObjectInstance) locationResponse.getContent()).getResource(1).getValue());
						
						LOG.warn("registration response after location");
						
						// observe slot
						ObserveRequest slotObserve = new ObserveRequest(32700,0);
						server.send(reg, slotObserve, new ResponseCallback<ObserveResponse>() {
							
							@Override
							public void onResponse(ObserveResponse slotResponse) {
								
								LOG.warn("registration response before slot");
								try {
									if (slotResponse.isSuccess()) {
										ParkingSlot newSlot = new ParkingSlot(
												(String) (((LwM2mObjectInstance) slotResponse.getContent()).getResource(1).getValue()), location_x,
												location_y, reg.getEndpoint(),
												(String) (((LwM2mObjectInstance) slotResponse.getContent()).getResource(2).getValue()),
												((Double) (((LwM2mObjectInstance) slotResponse.getContent()).getResource(3).getValue())).floatValue());
										slots.put(reg.getEndpoint(), newSlot);
										RunPythonCode.pipe(newSlot.x + "," + newSlot.y + "," + newSlot.status);
									}
								} catch (Exception ex) {
									LOG.warn("Ooops reg slot", ex);
								}
								
								LOG.warn("registration response after slot");
							}
						}, new ErrorCallback() {
							
							@Override
							public void onError(Exception e) {
								// TODO Auto-generated method stub
								e.printStackTrace();
							}
						});
						
						// observe counter
						ObserveRequest counterObserve = new ObserveRequest(32701, 0);
						server.send(reg, counterObserve, new ResponseCallback<ObserveResponse>() {

							@Override
							public void onResponse(ObserveResponse counterResponse) {
								
								LOG.warn("registration response before counter");
								
								try {
									// TODO Auto-generated method stub
									if (counterResponse.isSuccess()) {
										directions.put(reg.getEndpoint(),
												(String) (((LwM2mObjectInstance) counterResponse.getContent()).getResource(2).getValue()));
										counts.put(reg.getEndpoint(),
												(Integer) (((LwM2mObjectInstance) counterResponse.getContent()).getResource(3).getValue()));
									}
								} catch (Exception ex) {
									LOG.warn("Oops reg counter", ex);
								}

								LOG.warn("registration response after counter");
							}
							
						}, new ErrorCallback() {
							
							@Override
							public void onError(Exception e) {
								// TODO Auto-generated method stub
								e.printStackTrace();
							}
						});
					}
				}, new ErrorCallback() {
					
					@Override
					public void onError(Exception e) {
						// TODO Auto-generated method stub
						e.printStackTrace();
					}
				});
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		@Override
		public void updated(RegistrationUpdate update, Registration updatedRegistration,
				Registration previousRegistration) {

		}

		@Override
		public void unregistered(Registration registration, Collection<Observation> observations, boolean expired,
				Registration newReg) {
			try {
				directions.remove(registration.getEndpoint());
				counts.remove(registration.getEndpoint());
			} catch (Exception ex) {
			}
			try {
				slots.remove(registration.getEndpoint());
			} catch (Exception ex) {
			}
		}

	};

	public ParkingLotServlet(LeshanServer server) {
		this.server = server;
		server.getRegistrationService().addListener(this.registrationListener);
		server.getObservationService().addListener(this.observationListener);
		RunPythonCode.init();
	}

}

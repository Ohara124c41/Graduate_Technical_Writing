package org.eclipse.leshan.server.demo.servlet;

import java.io.*;
import java.util.*;

public class RunPythonCode {

	public static BufferedWriter out;

	public static void pipe(String msg) {
		String ret;

		try {
			out.write(msg + "\n");
			out.flush();
		} catch (Exception err) {

		}
	}

	public static void init() {

		String cmd = "python parkingLot.py";

		try {

			Process p = Runtime.getRuntime().exec(cmd);
			out = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
		}

		catch (Exception err) {
			//out.close();
			err.printStackTrace();
		}
	}
}

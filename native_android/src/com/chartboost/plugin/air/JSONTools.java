package com.chartboost.plugin.air;

import org.json.JSONException;
import org.json.JSONObject;

public class JSONTools {

	/** Create a JSONObject in a much less verbose way. */
	public static JSONObject JSON(JsonKV... kvs) {
		JSONObject json = new JSONObject();
		for (int i = 0; i < kvs.length; i++) {
			try {
				json.put(kvs[i].key, kvs[i].value);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return json;
	}

	/** Create a JSON key-value pair for use with {@link #Dictionary(JsonKV...)} */  
	public static JsonKV KV(String key, Object value) {
		return new JsonKV(key, value);
	}

	/** Key value pair class for use with {@link #Dictionary(JsonKV...)} */
	public static class JsonKV {
		private String key;
		private Object value;

		public JsonKV(String key, Object value) {
			this.key = key;
			this.value = value;
		}
	}
}

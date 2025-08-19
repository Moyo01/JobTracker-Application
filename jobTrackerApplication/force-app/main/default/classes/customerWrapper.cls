global with sharing class customerWrapper {
   
	global Integer created;
	global Integer account_balance;
	global String description;
	global Object error;
	global Boolean livemode;
	global Object subscription;
	global String token;
	global String id;
	global Map<String, String> metadata;
	
	global CardList cards;
	global String default_card;
	
	global class CardList {
		global Integer count;
		global String url;
		global List<SObject> stripeData;
	}

	// static cache to eliminate multiple lookups in same transaction
	private static Map<String, customerWrapper> mCustomers = new Map<String, customerWrapper>();
}
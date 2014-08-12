trigger UnspecifiedRequest on refedge__Unspecified_Request__c (before insert) {

	handler_UnspecifiedRequest.setRouteToUser(trigger.new);
}
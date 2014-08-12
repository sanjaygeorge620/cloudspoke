/*
Salesforce Sites Extended Controller
Created by Michael Fitzgerald
Created Date: April 2011
*/

public with sharing class SitesContentController Extends SitesController{

    public list<Perceptive_Site_Content__c> getPARTNER_SHOWCASE(){
        return sitesContent('Partner Showcase', 'Showcase');} //type, recordtype
     
    public list<Perceptive_Site_Content__c> getPARTNER_FEATURED_SHOWCASE(){
        return sitesFeaturedContent('Partner Showcase', 'Showcase');} //type, recordtype
     
    public list<Perceptive_Site_Content__c> getSOLUTION_FEATURED_SHOWCASE(){
        return sitesFeaturedContent('Solution Showcase', 'Showcase');} //type, recordtype
}
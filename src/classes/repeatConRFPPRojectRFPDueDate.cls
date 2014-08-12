public class repeatConRFPPRojectRFPDueDate {

    public void next() { 
        addMonth(1);
    }
    
    public void prev() { 
        addMonth(-1); 
    }
    
    public repeatConRFPPRojectRFPDueDate() {
    
        Date d = system.today(); // default to today 
        Integer mo = d.month(); 
        String m_param = System.currentPageReference().getParameters().get('mo');
        String y_param = System.currentPageReference().getParameters().get('yr');
        
        // allow a month to be passed in on the url as mo=10
        if (m_param != null) { 
        Integer mi = Integer.valueOf(m_param); 
        if (mi > 0 && mi <= 12) {
        d = Date.newInstance(d.year(),mi,d.day());
        }
        }
        // and year as yr=2008
        if (y_param != null) { 
            Integer yr = Integer.valueOf(y_param); 
            d = Date.newInstance(yr, d.month(), d.day());
        }
        
        setMonth(d);
    }
    
    public List<rfpMonth.Week> getWeeks() { 
        system.assert(month!=null,'month is null');
        return month.getWeeks();
    }
    
    public rfpMonth getMonth() { return month; } 
    
    
    private void setMonth(Date d) { 
        month = new rfpMonth(d); 
        system.assert(month != null); 
        
        Date[] da = month.getValidDateRange(); // gather events that fall in this month
        events = [ select id,account_Name__c, RFP_Type__c, Proposal_Writer_1__r.name, rfp_due_date__c,rfp_due_date_and_time__c
        from rfp_projects__c 
        where rfp_due_date__c >= :da[0] AND rfp_due_date__c <= :da[1]
        order by rfp_due_date_and_time__c];
        
        month.setEvents(events); // merge those events into the month class
        system.debug('events: ' + events);
    }
    
    private void addMonth(Integer val) { 
        Date d = month.getFirstDate();
        d = d.addMonths(val);
        setMonth(d);
    }
    
    private List<rfp_projects__c> events;
    private rfpMonth month;
}